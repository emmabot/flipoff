import UIKit

/// tvOS split-flap display app.
///
/// Fetches sayings from GitHub Pages, displays them on a 22×5 split-flap board
/// with Core Animation flip effects. Supports time-of-day message routing
/// (morning reminders 7-8am, bedtime quotes 7:30-8:30pm, default otherwise).
///
/// Siri Remote: swipe left = prev, swipe right = next, tap = next

private enum Config {
    static let autoRotationInterval: TimeInterval = 8.0
    static let timeCheckInterval: TimeInterval = 60.0
    static let riddleDelay: TimeInterval = 6.0
    static let morningStart: Double = 7.0
    static let morningEnd: Double = 8.0
    static let bedtimeStart: Double = 19.5
    static let bedtimeEnd: Double = 20.5
    static let weatherURL = "https://api.open-meteo.com/v1/forecast?latitude=37.87&longitude=-122.27&current=temperature_2m,weather_code&temperature_unit=fahrenheit"
    static let contentURL = "https://emmabot.github.io/flipoff/js/constants.js"
}

class ViewController: UIViewController {

    // MARK: - Message types

    private enum Message {
        case plain([String])
        case riddle(question: [String], answer: [String])

        var displayLines: [String] {
            switch self {
            case .plain(let lines): return lines
            case .riddle(let question, _): return question
            }
        }
    }

    // MARK: - Properties

    private var allMessages: [Message] = []
    private var morningMessages: [Message] = []
    private var bedtimeMessages: [Message] = []
    private var defaultMessages: [Message] = []

    private var activeMessages: [Message] = []
    private var currentIndex: Int = -1
    private var autoTimer: Timer?
    private var timeCheckTimer: Timer?
    private var riddleTimer: DispatchWorkItem?

    private let boardView = SplitFlapBoardView()
    private let statusLabel = UILabel()

    private let fallbackMessage: Message = .plain(["", "", "W + S", "", ""])

    // MARK: - Lifecycle

    deinit {
        autoTimer?.invalidate()
        timeCheckTimer?.invalidate()
        riddleTimer?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        UIApplication.shared.isIdleTimerDisabled = true
        setupBoard()
        setupStatusLabel()
        setupRemoteGestures()
        fetchMessages()
    }

    // MARK: - UI Setup

    private func setupBoard() {
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        NSLayoutConstraint.activate([
            boardView.topAnchor.constraint(equalTo: view.topAnchor),
            boardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func setupStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 36)
        statusLabel.textAlignment = .center
        statusLabel.text = "Loading..."
        view.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    // MARK: - Fetch & Parse Messages

    private func useFallback(reason: String) {
        print("[FlipOff] Using fallback message: \(reason)")
        DispatchQueue.main.async {
            self.statusLabel.text = reason
            self.allMessages = [self.fallbackMessage]
            self.morningMessages = [self.fallbackMessage]
            self.bedtimeMessages = [self.fallbackMessage]
            self.defaultMessages = [self.fallbackMessage]
            self.updateActiveMessages()
            self.statusLabel.removeFromSuperview()
            self.showNext()
            self.startAutoRotation()
            self.startTimeCheck()
        }
    }

    private func fetchMessages() {
        let urlString = Config.contentURL
        print("[FlipOff] Fetching messages from: \(urlString)")
        guard let url = URL(string: urlString) else {
            print("[FlipOff] ERROR: Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }

            if let error = error {
                print("[FlipOff] ERROR: Fetch failed: \(error.localizedDescription)")
                self.useFallback(reason: "Could not load messages")
                return
            }

            guard let data = data, let js = String(data: data, encoding: .utf8) else {
                print("[FlipOff] ERROR: No data or failed to decode as UTF-8")
                self.useFallback(reason: "Could not load messages")
                return
            }

            print("[FlipOff] Received \(data.count) bytes")
            let preview = String(js.prefix(200))
            print("[FlipOff] JS preview: \(preview)")

            let parsed = self.parseMessages(from: js)

            if parsed.isEmpty {
                self.useFallback(reason: "No messages found")
                return
            }

            let sections = self.categorizeSections(from: js, allMessages: parsed)

            let startUI = {
                DispatchQueue.main.async {
                    self.updateActiveMessages()
                    if !self.activeMessages.isEmpty {
                        self.statusLabel.removeFromSuperview()
                        self.showNext()
                        self.startAutoRotation()
                        self.startTimeCheck()
                    } else {
                        self.statusLabel.text = "No messages found"
                        print("[FlipOff] activeMessages is empty after updateActiveMessages")
                    }
                }
            }

            DispatchQueue.main.async {
                self.morningMessages = sections.morning
                self.bedtimeMessages = sections.bedtime
                self.defaultMessages = sections.defaults
                self.defaultMessages.shuffle()
                self.allMessages = parsed

                // Fetch weather and insert moon phase if morning slot is active
                let hour = self.currentHourFraction()
                if hour >= Config.morningStart && hour < Config.morningEnd {
                    let moonMsg: Message = .plain(["", "  TONIGHTS MOON", "  \(self.moonPhaseName())", "", ""])
                    self.fetchWeather { weatherMsg in
                        DispatchQueue.main.async {
                            if let weather = weatherMsg {
                                self.morningMessages.insert(weather, at: 0)
                                self.morningMessages.insert(moonMsg, at: 1)
                            } else {
                                self.morningMessages.insert(moonMsg, at: 0)
                            }
                            startUI()
                        }
                    }
                } else {
                    startUI()
                }
            }
        }.resume()
    }

    private func parseMessages(from js: String) -> [Message] {
        var results: [Message] = []
        let nsString = js as NSString

        // Parse riddle objects first so we can exclude their sub-arrays from plain matching
        let riddles = parseRiddles(from: js)
        print("[FlipOff] parseMessages: found \(riddles.count) riddles")

        // Collect byte ranges occupied by riddle objects to skip when parsing plain arrays
        var riddleRanges: [NSRange] = []
        let riddleObjPattern = #"\{\s*type:\s*'riddle'\s*,\s*question:\s*\[.*?\]\s*,\s*answer:\s*\[.*?\]\s*\}"#
        if let riddleObjRegex = try? NSRegularExpression(pattern: riddleObjPattern, options: .dotMatchesLineSeparators) {
            riddleRanges = riddleObjRegex.matches(in: js, range: NSRange(location: 0, length: nsString.length)).map { $0.range }
        }

        // Parse flat 5-element arrays as plain messages, skipping any inside riddle objects
        let plainPattern = #"\[\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*\]"#
        if let regex = try? NSRegularExpression(pattern: plainPattern) {
            let matches = regex.matches(in: js, range: NSRange(location: 0, length: nsString.length))
            print("[FlipOff] parseMessages: found \(matches.count) plain array matches (before riddle filtering)")

            var plainCount = 0
            for match in matches {
                // Skip arrays that fall inside a riddle object
                let matchRange = match.range
                let insideRiddle = riddleRanges.contains { riddleRange in
                    riddleRange.location <= matchRange.location &&
                    matchRange.location + matchRange.length <= riddleRange.location + riddleRange.length
                }
                if insideRiddle { continue }

                var row: [String] = []
                for i in 1...5 {
                    let range = match.range(at: i)
                    row.append(range.location != NSNotFound ? nsString.substring(with: range) : "")
                }
                if row.contains(where: { !$0.isEmpty }) {
                    results.append(.plain(row))
                    plainCount += 1
                }
            }
            print("[FlipOff] parseMessages: \(plainCount) plain messages after riddle filtering")
        }

        results.append(contentsOf: riddles)

        return results
    }

    private func parseRiddles(from js: String) -> [Message] {
        var results: [Message] = []
        let riddlePattern = #"type:\s*'riddle'\s*,\s*question:\s*\[\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*\]\s*,\s*answer:\s*\[\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*\]"#
        guard let regex = try? NSRegularExpression(pattern: riddlePattern) else {
            print("[FlipOff] ERROR: Failed to create riddle regex")
            return []
        }

        let nsString = js as NSString
        let matches = regex.matches(in: js, range: NSRange(location: 0, length: nsString.length))

        for match in matches {
            var question: [String] = []
            var answer: [String] = []
            for i in 1...5 {
                let range = match.range(at: i)
                question.append(range.location != NSNotFound ? nsString.substring(with: range) : "")
            }
            for i in 6...10 {
                let range = match.range(at: i)
                answer.append(range.location != NSNotFound ? nsString.substring(with: range) : "")
            }
            results.append(.riddle(question: question, answer: answer))
        }
        return results
    }

    /// Helper to get joined display text for content matching (only works on plain messages).
    private func plainJoined(_ msg: Message) -> String? {
        if case .plain(let lines) = msg { return lines.joined() }
        return nil
    }

    /// Remove duplicate messages by content (same line text = same message).
    private func deduplicateMessages(_ msgs: [Message]) -> [Message] {
        var seen = Set<String>()
        return msgs.filter { msg in
            let key: String
            switch msg {
            case .plain(let lines):
                key = "plain:" + lines.joined(separator: "|")
            case .riddle(let q, let a):
                key = "riddle:" + q.joined(separator: "|") + "=" + a.joined(separator: "|")
            }
            return seen.insert(key).inserted
        }
    }

    /// Extract the text between `const NAME = [` and the matching `];` for a given section name.
    private func extractSection(named name: String, from js: String) -> String? {
        let nsJS = js as NSString
        let pattern = "const \(name)\\s*=\\s*\\["
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: js, range: NSRange(location: 0, length: nsJS.length)) else {
            return nil
        }
        let startIdx = match.range.location + match.range.length
        let searchRange = NSRange(location: startIdx, length: nsJS.length - startIdx)
        let endRange = nsJS.range(of: "];", options: [], range: searchRange)
        guard endRange.location != NSNotFound else { return nil }
        let sectionRange = NSRange(location: startIdx, length: endRange.location - startIdx)
        return nsJS.substring(with: sectionRange)
    }

    /// Parse plain messages from a JS section substring.
    private func parsePlainMessages(from section: String) -> [Message] {
        var results: [Message] = []
        let nsSection = section as NSString
        let plainPattern = #"\[\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*\]"#
        guard let regex = try? NSRegularExpression(pattern: plainPattern) else { return [] }
        let matches = regex.matches(in: section, range: NSRange(location: 0, length: nsSection.length))
        for match in matches {
            var row: [String] = []
            for i in 1...5 {
                let range = match.range(at: i)
                row.append(range.location != NSNotFound ? nsSection.substring(with: range) : "")
            }
            if row.contains(where: { !$0.isEmpty }) {
                results.append(.plain(row))
            }
        }
        return results
    }

    private func categorizeSections(from js: String, allMessages: [Message])
        -> (morning: [Message], bedtime: [Message], defaults: [Message],
            morningReminders: [Message], morningJokes: [Message],
            bedtimeReminders: [Message], bedtimeQuotes: [Message]) {

        let morningReminders = extractSection(named: "MORNING_REMINDERS", from: js).map { parsePlainMessages(from: $0) } ?? []
        let morningJokes = extractSection(named: "MORNING_JOKES", from: js).map { parsePlainMessages(from: $0) } ?? []
        let bedtimeReminders = extractSection(named: "BEDTIME_REMINDERS", from: js).map { parsePlainMessages(from: $0) } ?? []
        let bedtimeQuotes = extractSection(named: "BEDTIME_QUOTES", from: js).map { parsePlainMessages(from: $0) } ?? []

        // Interleave morning reminders and jokes
        var morning: [Message] = []
        for i in 0..<max(morningReminders.count, morningJokes.count) {
            if i < morningReminders.count { morning.append(morningReminders[i]) }
            if i < morningJokes.count { morning.append(morningJokes[i]) }
        }

        // Interleave bedtime reminders and quotes
        var bedtime: [Message] = []
        for i in 0..<max(bedtimeReminders.count, bedtimeQuotes.count) {
            if i < bedtimeReminders.count { bedtime.append(bedtimeReminders[i]) }
            if i < bedtimeQuotes.count { bedtime.append(bedtimeQuotes[i]) }
        }

        // Default = everything not in morning/bedtime
        let morningSet = Set(morning.compactMap { plainJoined($0) })
        let bedtimeSet = Set(bedtime.compactMap { plainJoined($0) })
        let defaults = deduplicateMessages(allMessages.filter { msg in
            guard let joined = plainJoined(msg) else { return true } // riddles go to default
            return !morningSet.contains(joined) && !bedtimeSet.contains(joined)
        })

        print("[FlipOff] categorizeSections: morning=\(morning.count), bedtime=\(bedtime.count), default=\(defaults.count)")

        return (morning.isEmpty ? allMessages : morning,
                bedtime.isEmpty ? allMessages : bedtime,
                defaults.isEmpty ? allMessages : defaults,
                morningReminders, morningJokes,
                bedtimeReminders, bedtimeQuotes)
    }

    // MARK: - Weather

    private static let weatherCodeLabels: [Int: String] = [
        0: "CLEAR", 1: "MOSTLY CLEAR", 2: "PARTLY CLOUDY", 3: "CLOUDY",
        45: "FOGGY", 48: "FOGGY",
        51: "DRIZZLE", 53: "DRIZZLE", 55: "DRIZZLE",
        61: "RAINY", 63: "RAINY", 65: "HEAVY RAIN",
        71: "SNOWY", 73: "SNOWY", 75: "HEAVY SNOW",
        80: "RAIN SHOWERS", 81: "RAIN SHOWERS", 82: "HEAVY SHOWERS",
        95: "STORMY", 96: "STORMY", 99: "STORMY",
    ]

    private func moonPhaseName() -> String {
        let knownNewMoon = DateComponents(calendar: .current, year: 2000, month: 1, day: 6).date!
        let daysSince = Date().timeIntervalSince(knownNewMoon) / 86400.0
        let lunarCycle = 29.53
        let phase = daysSince.truncatingRemainder(dividingBy: lunarCycle)
        let normalizedPhase = phase < 0 ? phase + lunarCycle : phase

        switch normalizedPhase {
        case 0..<1.85: return "NEW MOON"
        case 1.85..<5.53: return "WAXING CRESCENT"
        case 5.53..<9.22: return "FIRST QUARTER"
        case 9.22..<12.91: return "WAXING GIBBOUS"
        case 12.91..<16.61: return "FULL MOON"
        case 16.61..<20.30: return "WANING GIBBOUS"
        case 20.30..<23.99: return "LAST QUARTER"
        case 23.99..<27.68: return "WANING CRESCENT"
        default: return "NEW MOON"
        }
    }

    private func fetchWeather(completion: @escaping (Message?) -> Void) {
        guard let url = URL(string: Config.weatherURL) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let current = json["current"] as? [String: Any],
                  let temp = current["temperature_2m"] as? Double,
                  let code = current["weather_code"] as? Int else {
                print("[FlipOff] Weather fetch failed: \(error?.localizedDescription ?? "parse error")")
                completion(nil)
                return
            }
            let roundedTemp = Int(temp.rounded())
            let label = Self.weatherCodeLabels[code] ?? "CLEAR"
            let msg: Message = .plain(["", "  GOOD MORNING", "  \(roundedTemp)°F  \(label)", "", ""])
            print("[FlipOff] Weather: \(roundedTemp)°F \(label)")
            completion(msg)
        }.resume()
    }

    // MARK: - Time-of-Day Routing

    private func currentHourFraction() -> Double {
        let cal = Calendar.current
        let comps = cal.dateComponents([.hour, .minute], from: Date())
        return Double(comps.hour ?? 0) + Double(comps.minute ?? 0) / 60.0
    }

    private func updateActiveMessages() {
        let hour = currentHourFraction()
        let previousMessages = activeMessages

        let slot: String
        if hour >= Config.morningStart && hour < Config.morningEnd {
            activeMessages = morningMessages
            slot = "morning"
        } else if hour >= Config.bedtimeStart && hour < Config.bedtimeEnd {
            activeMessages = bedtimeMessages
            slot = "bedtime"
        } else {
            activeMessages = defaultMessages
            slot = "default"
        }

        print("[FlipOff] updateActiveMessages: slot=\(slot), hour=\(hour), count=\(activeMessages.count)")

        // Shuffle only the default set (morning/bedtime keep their interleaved order)
        if previousMessages.count != activeMessages.count || previousMessages.isEmpty {
            currentIndex = -1
        }
    }

    private func startTimeCheck() {
        timeCheckTimer?.invalidate()
        timeCheckTimer = Timer.scheduledTimer(withTimeInterval: Config.timeCheckInterval, repeats: true) { [weak self] _ in
            self?.updateActiveMessages()
        }
    }

    // MARK: - Message Display

    private static let riddleDelay: TimeInterval = Config.riddleDelay

    private func cancelRiddleTimer() {
        riddleTimer?.cancel()
        riddleTimer = nil
    }

    private func isJoke(_ lines: [String]) -> Bool {
        // A joke is a 5-element array where rows 1, 2, and 3 all have text,
        // but row 3 is not a quote attribution (starts with "-" or contains " - ")
        return lines.count == 5
            && !lines[1].isEmpty
            && !lines[2].isEmpty
            && !lines[3].isEmpty
            && !lines[3].hasPrefix("-")
            && !lines[3].contains(" - ")
    }

    private func showWithDelay(question: [String], answer: [String]) {
        cancelRiddleTimer()
        autoTimer?.invalidate()
        autoTimer = nil
        boardView.display(message: question)
        let work = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.boardView.display(message: answer)
            self.riddleTimer = nil
            self.startAutoRotation()
        }
        riddleTimer = work
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.riddleDelay, execute: work)
    }

    private func displayMessage(_ msg: Message) {
        cancelRiddleTimer()

        switch msg {
        case .plain(let lines):
            if isJoke(lines) {
                // Joke: show question first, then punchline after delay
                let question = [lines[0], lines[1], lines[2], "", lines[4]]
                let answer = ["", "", lines[3], "", ""]
                showWithDelay(question: question, answer: answer)
            } else {
                boardView.display(message: lines)
            }
        case .riddle(let question, let answer):
            showWithDelay(question: question, answer: answer)
        }
    }

    private func showNext() {
        guard !activeMessages.isEmpty else { return }
        currentIndex = (currentIndex + 1) % activeMessages.count
        displayMessage(activeMessages[currentIndex])
    }

    private func showPrev() {
        guard !activeMessages.isEmpty else { return }
        currentIndex = (currentIndex - 1 + activeMessages.count) % activeMessages.count
        displayMessage(activeMessages[currentIndex])
    }

    // MARK: - Auto-Rotation

    private func startAutoRotation() {
        autoTimer?.invalidate()
        cancelRiddleTimer()
        // ~8 seconds matches MESSAGE_INTERVAL + TOTAL_TRANSITION from web
        autoTimer = Timer.scheduledTimer(withTimeInterval: Config.autoRotationInterval, repeats: true) { [weak self] _ in
            self?.showNext()
        }
    }

    // MARK: - Siri Remote Gestures

    private func setupRemoteGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        view.addGestureRecognizer(tap)

        let playPause = UITapGestureRecognizer(target: self, action: #selector(handlePlayPause))
        playPause.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        view.addGestureRecognizer(playPause)
    }

    @objc private func handleSwipeLeft() {
        showPrev()
        startAutoRotation()
    }

    @objc private func handleSwipeRight() {
        showNext()
        startAutoRotation()
    }

    @objc private func handleTap() {
        showNext()
        startAutoRotation()
    }

    @objc private func handlePlayPause() {
        let muted = FlipSoundEngine.shared.toggleMute()
        print("[FlipOff] Sound \(muted ? "OFF" : "ON")")
    }
}
