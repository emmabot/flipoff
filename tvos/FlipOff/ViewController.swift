import UIKit

/// tvOS split-flap display app.
///
/// Fetches sayings from GitHub Pages, displays them on a 22×5 split-flap board
/// with Core Animation flip effects. Supports time-of-day message routing
/// (morning reminders 7-8am, bedtime quotes 7:30-8:30pm, default otherwise).
///
/// Siri Remote: swipe left = prev, swipe right = next, tap = next

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
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
        let urlString = "https://emmabot.github.io/flipoff/js/constants.js"
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

            DispatchQueue.main.async {
                self.morningMessages = sections.morning
                self.bedtimeMessages = sections.bedtime
                self.defaultMessages = sections.defaults
                self.defaultMessages.shuffle()
                self.allMessages = parsed
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

    private func categorizeSections(from js: String, allMessages: [Message])
        -> (morning: [Message], bedtime: [Message], defaults: [Message]) {
        // Riddles only go into default set (matching web behavior).
        // Morning/bedtime categorization uses string content matching on plain messages only.

        var morning: [Message] = []
        var bedtime: [Message] = []
        var morningJoined: [String] = []

        for msg in allMessages {
            guard let joined = plainJoined(msg) else { continue }
            if joined.contains("BRUSH YOUR TEETH") || joined.contains("BRUSH YOUR HAIR")
                || joined.contains("PUT YOUR SOCKS ON") || joined.contains("BE NICE")
                || joined.contains("GET READY FOR A") {
                morning.append(msg)
                morningJoined.append(joined)
            }
            // Note: "BRUSH YOUR TEETH" appears in both morning and bedtime reminders in the web version.
            // Both sets should contain it.
            if joined.contains("SWEET DREAMS") || joined.contains("SAY GOODNIGHT")
                || joined.contains("PACK YOUR BACKPACK") || joined.contains("READ A BOOK")
                || joined.contains("DRINK SOME WATER") || joined.contains("YOU DID GREAT TODAY")
                || joined.contains("BRUSH YOUR TEETH")
                || joined.contains("NEW ADVENTURE") || joined.contains("CHANGE YOUR CLOTHES")
                || joined.contains("TO SLEEP PERCHANCE") || joined.contains("NO MISTAKES YET")
                || joined.contains("BRAVER THAN") || joined.contains("MOON IS A FRIEND")
                || joined.contains("BEST MEDITATION") || joined.contains("EVERY SUNSET")
                || joined.contains("EVEN SUPERHEROES") || joined.contains("DARKEST JUST BEFORE")
                || joined.contains("AND SO TO BED") {
                bedtime.append(msg)
            }
        }

        // Morning also includes morning jokes (first 5 that match breakfast/school theme)
        for msg in allMessages {
            guard let joined = plainJoined(msg) else { continue }
            if (joined.contains("MICE KRISPIES") || joined.contains("CRACK UP")
                || joined.contains("HIGH SCHOOL") || joined.contains("ELF-ABET")
                || joined.contains("BACON") && joined.contains("EGG CRACKED"))
                && !morningJoined.contains(joined) {
                morning.append(msg)
                morningJoined.append(joined)
                if morning.count >= 10 { break }
            }
        }

        // Deduplicate morning and bedtime (identical arrays appear multiple times in JS source)
        morning = deduplicateMessages(morning)
        bedtime = deduplicateMessages(bedtime)

        // Default = everything not in morning/bedtime (riddles naturally land here)
        let morningSet = Set(morningJoined)
        let bedtimeSet = Set(bedtime.compactMap { plainJoined($0) })
        let defaults = deduplicateMessages(allMessages.filter { msg in
            guard let joined = plainJoined(msg) else { return true } // riddles go to default
            return !morningSet.contains(joined) && !bedtimeSet.contains(joined)
        })

        print("[FlipOff] categorizeSections: morning=\(morning.count), bedtime=\(bedtime.count), default=\(defaults.count)")

        return (morning.isEmpty ? allMessages : morning,
                bedtime.isEmpty ? allMessages : bedtime,
                defaults.isEmpty ? allMessages : defaults)
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
        if hour >= 7.0 && hour < 8.0 {
            activeMessages = morningMessages
            slot = "morning"
        } else if hour >= 19.5 && hour < 20.5 {
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
        timeCheckTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateActiveMessages()
        }
    }

    // MARK: - Message Display

    private static let riddleDelay: TimeInterval = 6.0

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
        autoTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { [weak self] _ in
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
}
