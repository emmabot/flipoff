import UIKit

/// tvOS split-flap display app.
///
/// Fetches sayings from GitHub Pages JSON, displays them on a 22×5 split-flap
/// board with Core Animation flip effects. Supports time-of-day message routing
/// (morning 7-8am, bedtime 7:30-8:30pm, default otherwise).
///
/// Siri Remote: swipe left = prev, swipe right = next, tap = next
/// Menu button toggles settings overlay for mode switching and sound toggle.

class ViewController: UIViewController, MessageSchedulerDelegate, ModePickerDelegate {

    // MARK: - Properties

    private let modeKey = "selectedMode"
    private let soundMuteKey = "soundMuted"

    private var boardView: SplitFlapBoardView!
    private let statusLabel = UILabel()
    private let scheduler = MessageScheduler()
    private var riddleWork: DispatchWorkItem?
    private var currentMode: String = "kids"
    private var fetchRetryCount = 0
    private static let maxFetchRetries = 3
    private static let fetchRetryDelay: TimeInterval = 10.0

    // Settings overlay
    private var settingsOverlay: UIView?
    private var settingsButtons: [UIButton] = []
    private var soundButton: UIButton?

    // Eng-M7: Use shared ModeDefinition instead of duplicate tuple
    private let modes = ModeDefinition.all

    // MARK: - Lifecycle

    deinit {
        scheduler.stop()
        riddleWork?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        UIApplication.shared.isIdleTimerDisabled = true

        // Restore sound mute state
        if UserDefaults.standard.object(forKey: soundMuteKey) != nil {
            FlipSoundEngine.shared.isMuted = UserDefaults.standard.bool(forKey: soundMuteKey)
        }

        if let savedMode = UserDefaults.standard.string(forKey: modeKey) {
            startBoard(mode: savedMode)
        } else {
            showModePicker()
        }
    }

    // MARK: - Mode Picker

    private func showModePicker() {
        let picker = ModePickerViewController()
        picker.delegate = self
        addChild(picker)
        view.addSubview(picker.view)
        picker.view.frame = view.bounds
        picker.didMove(toParent: self)
    }

    func modePicker(_ picker: ModePickerViewController, didSelect mode: String) {
        UserDefaults.standard.set(mode, forKey: modeKey)

        // Des-C2: Animated transition — zoom up selected card + cross-dissolve to board
        // Set up board behind the picker
        startBoard(mode: mode)

        // Animate the picker view out with zoom + fade
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            picker.view.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            picker.view.alpha = 0
        }, completion: { _ in
            picker.willMove(toParent: nil)
            picker.view.removeFromSuperview()
            picker.removeFromParent()
        })
    }

    // MARK: - Board Setup

    private func startBoard(mode: String) {
        currentMode = mode

        // Clean up existing board if switching modes
        scheduler.stop()
        riddleWork?.cancel()
        riddleWork = nil
        boardView?.removeFromSuperview()
        statusLabel.removeFromSuperview()

        setupBoard()

        // Only set up gestures once
        if view.gestureRecognizers?.isEmpty ?? true {
            setupGestures()
        }

        // Show board scramble as loading state instead of "Loading..." text
        boardView.startLoadingScramble()

        fetchRetryCount = 0
        fetchMessages(mode: mode)
    }

    private func fetchMessages(mode: String) {
        MessageService.shared.fetch(mode: mode) { [weak self] success in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if success {
                    self.boardView.stopLoadingScramble()
                    self.scheduler.delegate = self
                    self.scheduler.start()
                } else {
                    self.fetchRetryCount += 1
                    if self.fetchRetryCount < Self.maxFetchRetries {
                        print("[FlipOff] Fetch failed, retrying in \(Self.fetchRetryDelay)s (attempt \(self.fetchRetryCount)/\(Self.maxFetchRetries))")
                        DispatchQueue.main.asyncAfter(deadline: .now() + Self.fetchRetryDelay) { [weak self] in
                            guard let self = self else { return }
                            self.fetchMessages(mode: mode)
                        }
                    } else {
                        self.boardView.stopLoadingScramble()
                        self.statusLabel.text = "Could not load messages"
                        self.view.addSubview(self.statusLabel)
                        self.setupStatusLabelConstraints()
                        print("[FlipOff] Failed to fetch messages after \(Self.maxFetchRetries) retries")
                    }
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

    private func setupStatusLabelConstraints() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 36)
        statusLabel.textAlignment = .center
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

        let menuPress = UITapGestureRecognizer(target: self, action: #selector(handleMenu))
        menuPress.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        view.addGestureRecognizer(menuPress)
    }

    // MARK: - Gestures

    @objc private func handleSwipeRight() {
        if settingsOverlay == nil {
            scheduler.showNext()
        }
    }

    @objc private func handleSwipeLeft() {
        if settingsOverlay == nil {
            scheduler.showPrev()
        }
    }

    @objc private func handleTap() {
        if settingsOverlay == nil {
            scheduler.showNext()
        }
    }

    @objc private func handlePlayPause() {
        let muted = FlipSoundEngine.shared.toggleMute()
        UserDefaults.standard.set(muted, forKey: soundMuteKey)
        print("[FlipOff] Sound \(muted ? "OFF" : "ON")")
    }

    @objc private func handleMenu() {
        if settingsOverlay != nil {
            dismissSettings()
        } else {
            showSettings()
        }
    }

    // MARK: - Settings Overlay

    private func showSettings() {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        view.addSubview(overlay)
        settingsOverlay = overlay

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "SETTINGS"
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 48, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#F0E6D0")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(titleLabel)

        // Mode card buttons
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(stackView)

        settingsButtons = []
        for (i, mode) in modes.enumerated() {
            let button = createSettingsModeButton(mode: mode, tag: i, isActive: mode.id == currentMode)
            stackView.addArrangedSubview(button)
            settingsButtons.append(button)
        }

        // Sound toggle button
        let muted = FlipSoundEngine.shared.isMuted
        let sndButton = UIButton(type: .custom)
        sndButton.setTitle("SOUND: \(muted ? "OFF" : "ON")", for: .normal)
        sndButton.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 32, weight: .medium)
        sndButton.setTitleColor(UIColor(hex: "#888888"), for: .normal)
        sndButton.addTarget(self, action: #selector(settingsSoundToggled), for: .primaryActionTriggered)
        sndButton.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(sndButton)
        soundButton = sndButton

        // Hint
        let hintLabel = UILabel()
        hintLabel.text = "Navigate · Click to select · Menu to close"
        hintLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        hintLabel.textColor = UIColor(hex: "#555555")
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(hintLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalToConstant: 900),
            stackView.heightAnchor.constraint(equalToConstant: 280),
            sndButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            sndButton.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
            hintLabel.bottomAnchor.constraint(equalTo: overlay.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            hintLabel.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
        ])
    }

    private func createSettingsModeButton(mode: (id: String, title: String, color: UIColor), tag: Int, isActive: Bool) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.backgroundColor = UIColor(hex: "#2A2A2A")
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(settingsModeSelected(_:)), for: .primaryActionTriggered)

        // Color accent bar at top
        let accentBar = UIView()
        accentBar.backgroundColor = mode.color
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        accentBar.isUserInteractionEnabled = false
        button.addSubview(accentBar)

        let label = UILabel()
        label.text = mode.title
        label.font = UIFont.monospacedSystemFont(ofSize: 36, weight: .bold)
        label.textColor = UIColor(hex: "#F0E6D0")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        button.addSubview(label)

        if isActive {
            let activeLabel = UILabel()
            activeLabel.text = "CURRENT"
            activeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            activeLabel.textColor = UIColor(hex: "#E8A840")
            activeLabel.textAlignment = .center
            activeLabel.translatesAutoresizingMaskIntoConstraints = false
            activeLabel.isUserInteractionEnabled = false
            button.addSubview(activeLabel)

            NSLayoutConstraint.activate([
                activeLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
                activeLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            ])
        }

        NSLayoutConstraint.activate([
            accentBar.topAnchor.constraint(equalTo: button.topAnchor),
            accentBar.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            accentBar.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            accentBar.heightAnchor.constraint(equalToConstant: 5),
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: isActive ? -12 : 0),
        ])

        return button
    }

    @objc private func settingsModeSelected(_ sender: UIButton) {
        let mode = modes[sender.tag]
        if mode.id != currentMode {
            UserDefaults.standard.set(mode.id, forKey: modeKey)
            dismissSettings()
            startBoard(mode: mode.id)
        } else {
            dismissSettings()
        }
    }

    @objc private func settingsSoundToggled() {
        let muted = FlipSoundEngine.shared.toggleMute()
        UserDefaults.standard.set(muted, forKey: soundMuteKey)
        soundButton?.setTitle("SOUND: \(muted ? "OFF" : "ON")", for: .normal)
        print("[FlipOff] Sound \(muted ? "OFF" : "ON")")
    }

    private func dismissSettings() {
        settingsOverlay?.removeFromSuperview()
        settingsOverlay = nil
        settingsButtons = []
        soundButton = nil
    }

    // Focus handling for settings overlay
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            // Settings mode buttons
            if let prev = context.previouslyFocusedView as? UIButton,
               self.settingsButtons.contains(prev) {
                prev.backgroundColor = UIColor(hex: "#2A2A2A")
                prev.transform = .identity
            }
            if let next = context.nextFocusedView as? UIButton,
               self.settingsButtons.contains(next) {
                next.backgroundColor = UIColor(hex: "#333333")
                next.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
            }
            // Sound button
            if let prev = context.previouslyFocusedView as? UIButton,
               prev === self.soundButton {
                prev.setTitleColor(UIColor(hex: "#888888"), for: .normal)
                prev.transform = .identity
            }
            if let next = context.nextFocusedView as? UIButton,
               next === self.soundButton {
                next.setTitleColor(UIColor(hex: "#E8A840"), for: .normal)
                next.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }, completion: nil)
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
