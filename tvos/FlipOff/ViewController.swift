import UIKit

/// tvOS split-flap display app.
///
/// Fetches sayings from GitHub Pages JSON, displays them on a 22×5 split-flap
/// board with Core Animation flip effects. Supports time-of-day message routing
/// (morning 7-8am, bedtime 7:30-8:30pm, default otherwise).
///
/// Siri Remote: swipe left = prev, swipe right = next, tap = next

class ViewController: UIViewController, MessageSchedulerDelegate {

    // MARK: - Properties

    private var boardView: SplitFlapBoardView!
    private let statusLabel = UILabel()
    private let scheduler = MessageScheduler()
    private var riddleWork: DispatchWorkItem?

    // MARK: - Lifecycle

    deinit {
        scheduler.stop()
        riddleWork?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        UIApplication.shared.isIdleTimerDisabled = true

        setupBoard()
        setupStatusLabel()
        setupGestures()

        // Fetch messages then start rotation
        MessageService.shared.fetch { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if success {
                    self.statusLabel.removeFromSuperview()
                    self.scheduler.delegate = self
                    self.scheduler.start()
                } else {
                    self.statusLabel.text = "Could not load messages"
                    print("[FlipOff] Failed to fetch messages")
                }
            }
        }
    }

    // MARK: - UI Setup

    private func setupBoard() {
        boardView = SplitFlapBoardView()
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        NSLayoutConstraint.activate([
            boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            boardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            boardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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

    private func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        view.addGestureRecognizer(tap)

        let playPause = UITapGestureRecognizer(target: self, action: #selector(handlePlayPause))
        playPause.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        view.addGestureRecognizer(playPause)
    }

    // MARK: - Gestures

    @objc private func handleSwipeRight() {
        scheduler.showNext()
    }

    @objc private func handleSwipeLeft() {
        scheduler.showPrev()
    }

    @objc private func handleTap() {
        scheduler.showNext()
    }

    @objc private func handlePlayPause() {
        let muted = FlipSoundEngine.shared.toggleMute()
        print("[FlipOff] Sound \(muted ? "OFF" : "ON")")
    }

    // MARK: - MessageSchedulerDelegate

    func scheduler(_ scheduler: MessageScheduler, displayMessage message: Message) {
        boardView.display(message: message.displayLines)
    }

    func scheduler(_ scheduler: MessageScheduler, showDelayed question: [String], answer: [String], delay: TimeInterval) {
        riddleWork?.cancel()
        boardView.display(message: question)
        let work = DispatchWorkItem { [weak self] in
            self?.boardView.display(message: answer)
            self?.riddleWork = nil
            scheduler.riddleAnswerShown()
        }
        riddleWork = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }
}
