import Foundation

protocol MessageSchedulerDelegate: AnyObject {
    func scheduler(_ scheduler: MessageScheduler, displayMessage message: Message)
    func scheduler(_ scheduler: MessageScheduler, showDelayed question: [String], answer: [String], delay: TimeInterval)
}

class MessageScheduler {
    weak var delegate: MessageSchedulerDelegate?

    private var autoTimer: Timer?
    private var riddleTimer: DispatchWorkItem?
    private var timeCheckTimer: Timer?

    private var activeMessages: [Message] = []
    private var currentIndex = -1
    private var currentSlot: String = ""

    private var messagesSinceRPS = 0
    private var rpsInterval = Int.random(in: 3...5)

    private let autoInterval: TimeInterval
    private let riddleDelay: TimeInterval

    private var becomeActiveObserver: NSObjectProtocol?

    init(autoInterval: TimeInterval = 12.0, riddleDelay: TimeInterval = 6.0) {
        self.autoInterval = autoInterval
        self.riddleDelay = riddleDelay
    }

    func start() {
        updateActiveMessages()
        startAutoRotation()

        timeCheckTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateActiveMessages()
        }

        // Re-check time slot when app returns from background
        becomeActiveObserver = NotificationCenter.default.addObserver(
            forName: .appDidBecomeActive, object: nil, queue: .main
        ) { [weak self] _ in
            self?.checkTimeSlotOnResume()
        }
    }

    func stop() {
        autoTimer?.invalidate()
        autoTimer = nil
        timeCheckTimer?.invalidate()
        timeCheckTimer = nil
        riddleTimer?.cancel()
        riddleTimer = nil
        if let observer = becomeActiveObserver {
            NotificationCenter.default.removeObserver(observer)
            becomeActiveObserver = nil
        }
    }

    /// Called when app becomes active — force re-check the time slot
    private func checkTimeSlotOnResume() {
        let slot = currentTimeSlot()
        if slot != currentSlot {
            print("[FlipOff] Time slot changed on resume: \(currentSlot) → \(slot)")
            updateActiveMessages()
        }
    }

    func showNext() {
        guard !activeMessages.isEmpty else { return }

        messagesSinceRPS += 1

        if messagesSinceRPS >= rpsInterval, let rps = MessageService.shared.rpsMessages.randomElement() {
            messagesSinceRPS = 0
            rpsInterval = Int.random(in: 3...5)

            if case .riddle(let question, let answer) = rps {
                cancelRiddleTimer()
                autoTimer?.invalidate()
                autoTimer = nil
                delegate?.scheduler(self, showDelayed: question, answer: answer, delay: riddleDelay)
                return
            }
        }

        currentIndex = (currentIndex + 1) % activeMessages.count
        displayCurrent()
    }

    func showPrev() {
        guard !activeMessages.isEmpty else { return }

        currentIndex = (currentIndex - 1 + activeMessages.count) % activeMessages.count
        displayCurrent()
    }

    func riddleAnswerShown() {
        startAutoRotation()
    }

    // MARK: - Private

    private func displayCurrent() {
        guard activeMessages.indices.contains(currentIndex) else {
            print("[FlipOff] displayCurrent: currentIndex \(currentIndex) out of bounds (count: \(activeMessages.count))")
            return
        }
        let msg = activeMessages[currentIndex]
        cancelRiddleTimer()

        switch msg {
        case .riddle(let question, let answer):
            autoTimer?.invalidate()
            autoTimer = nil
            delegate?.scheduler(self, showDelayed: question, answer: answer, delay: riddleDelay)

        case .joke(let lines):
            autoTimer?.invalidate()
            autoTimer = nil
            let question = [lines[0], lines[1], lines[2], "", lines[4]]
            let answer = ["", "", lines[3], "", ""]
            delegate?.scheduler(self, showDelayed: question, answer: answer, delay: riddleDelay)

        case .plain, .fact:
            delegate?.scheduler(self, displayMessage: msg)
            startAutoRotation()
        }
    }

    private func startAutoRotation() {
        autoTimer?.invalidate()
        autoTimer = Timer.scheduledTimer(withTimeInterval: autoInterval, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.showNext()
        }
    }

    private func cancelRiddleTimer() {
        riddleTimer?.cancel()
        riddleTimer = nil
    }

    private func updateActiveMessages() {
        let slot = currentTimeSlot()
        guard slot != currentSlot else { return }
        currentSlot = slot

        let service = MessageService.shared
        switch slot {
        case "morning":
            activeMessages = service.morningMessages
            if let config = service.config {
                WeatherService.shared.fetchWeather(config: config.weather) { [weak self] weatherMsg in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        if let weather = weatherMsg {
                            self.activeMessages.insert(weather, at: 0)
                            if self.currentIndex >= 0 { self.currentIndex += 1 }
                        }
                        let moon = WeatherService.shared.moonMessage()
                        self.activeMessages.insert(moon, at: min(1, self.activeMessages.count))
                        if self.currentIndex >= 1 { self.currentIndex += 1 }
                    }
                }
            }
        case "bedtime":
            activeMessages = service.bedtimeMessages
        default:
            activeMessages = service.defaultMessages
        }

        print("[FlipOff] Active slot: \(slot), messages: \(activeMessages.count)")
        currentIndex = -1
        showNext()
    }

    private func currentTimeSlot() -> String {
        let cal = Calendar.current
        let hour = cal.component(.hour, from: Date())
        let minute = cal.component(.minute, from: Date())
        let t = Double(hour) + Double(minute) / 60.0

        if t >= 7.0 && t < 8.0 { return "morning" }
        if t >= 19.5 && t < 20.5 { return "bedtime" }
        return "default"
    }
}

