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

    private struct TimeSlot {
        let startHour: Double
        let endHour: Double
        let messages: [[String]]
    }

    // MARK: - Properties

    private var allMessages: [[String]] = []
    private var morningMessages: [[String]] = []
    private var bedtimeMessages: [[String]] = []
    private var defaultMessages: [[String]] = []

    private var activeMessages: [[String]] = []
    private var currentIndex: Int = -1
    private var autoTimer: Timer?
    private var timeCheckTimer: Timer?

    private let boardView = SplitFlapBoardView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupBoard()
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

    // MARK: - Fetch & Parse Messages

    private func fetchMessages() {
        let urlString = "https://emmabot.github.io/flipoff/js/constants.js"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil,
                  let js = String(data: data, encoding: .utf8) else {
                return
            }

            let parsed = self.parseMessages(from: js)
            let sections = self.categorizeSections(from: js, allMessages: parsed)

            DispatchQueue.main.async {
                self.morningMessages = sections.morning
                self.bedtimeMessages = sections.bedtime
                self.defaultMessages = sections.defaults
                self.allMessages = parsed
                self.updateActiveMessages()
                if !self.activeMessages.isEmpty {
                    self.showNext()
                    self.startAutoRotation()
                    self.startTimeCheck()
                }
            }
        }.resume()
    }

    private func parseMessages(from js: String) -> [[String]] {
        var results: [[String]] = []
        let pattern = #"\[\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*\]"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }

        let nsString = js as NSString
        let matches = regex.matches(in: js, range: NSRange(location: 0, length: nsString.length))

        for match in matches {
            var row: [String] = []
            for i in 1...5 {
                let range = match.range(at: i)
                row.append(range.location != NSNotFound ? nsString.substring(with: range) : "")
            }
            if row.contains(where: { !$0.isEmpty }) {
                results.append(row)
            }
        }
        return results
    }

    private func categorizeSections(from js: String, allMessages: [[String]])
        -> (morning: [[String]], bedtime: [[String]], defaults: [[String]]) {
        // Find MORNING_REMINDERS section messages (first 10 after morning marker)
        // Find BEDTIME section messages
        // The rest are defaults
        // Simple heuristic: use known content markers

        var morning: [[String]] = []
        var bedtime: [[String]] = []

        for msg in allMessages {
            let joined = msg.joined()
            if joined.contains("BRUSH YOUR TEETH") || joined.contains("BRUSH YOUR HAIR")
                || joined.contains("PUT YOUR SOCKS ON") || joined.contains("BE NICE")
                || joined.contains("GET READY FOR A") {
                morning.append(msg)
            }
            if joined.contains("SWEET DREAMS") || joined.contains("SAY GOODNIGHT")
                || joined.contains("PACK YOUR BACKPACK") || joined.contains("READ A BOOK")
                || joined.contains("DRINK SOME WATER") || joined.contains("YOU DID GREAT TODAY")
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
            let joined = msg.joined()
            if (joined.contains("MICE KRISPIES") || joined.contains("CRACK UP")
                || joined.contains("HIGH SCHOOL") || joined.contains("ELF-ABET")
                || joined.contains("BACON") && joined.contains("EGG CRACKED"))
                && !morning.contains(where: { $0 == msg }) {
                morning.append(msg)
                if morning.count >= 10 { break }
            }
        }

        // Default = everything not in morning/bedtime
        let defaults = allMessages.filter { msg in
            !morning.contains(where: { $0 == msg }) && !bedtime.contains(where: { $0 == msg })
        }

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

        if hour >= 7.0 && hour < 8.0 {
            activeMessages = morningMessages
        } else if hour >= 19.5 && hour < 20.5 {
            activeMessages = bedtimeMessages
        } else {
            activeMessages = defaultMessages
        }

        // Shuffle when switching sets
        if previousMessages.count != activeMessages.count || previousMessages.isEmpty {
            activeMessages.shuffle()
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

    private func showNext() {
        guard !activeMessages.isEmpty else { return }
        currentIndex = (currentIndex + 1) % activeMessages.count
        boardView.display(message: activeMessages[currentIndex])
    }

    private func showPrev() {
        guard !activeMessages.isEmpty else { return }
        currentIndex = (currentIndex - 1 + activeMessages.count) % activeMessages.count
        boardView.display(message: activeMessages[currentIndex])
    }

    // MARK: - Auto-Rotation

    private func startAutoRotation() {
        autoTimer?.invalidate()
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
