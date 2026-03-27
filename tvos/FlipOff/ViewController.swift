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
    private let hasLaunchedKey = "hasLaunchedBefore"  // Des-D2: first-launch tracking

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
        } else if !UserDefaults.standard.bool(forKey: hasLaunchedKey) {
            // Des-D2: First-launch title animation
            UserDefaults.standard.set(true, forKey: hasLaunchedKey)
            showFirstLaunchAnimation()
        } else {
            showModePicker()
        }
    }

    // MARK: - Des-D2: First-Launch Title Animation

    /// On the very first launch, show a black screen, flip in "LIL SAUCE", pause, then dissolve to mode picker.
    private func showFirstLaunchAnimation() {
        // Create a temporary board for the title animation
        let titleBoard = SplitFlapBoardView()
        titleBoard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleBoard)
        NSLayoutConstraint.activate([
            titleBoard.topAnchor.constraint(equalTo: view.topAnchor),
            titleBoard.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            titleBoard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBoard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        // Wait a beat for layout, then flip in the title
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            titleBoard.display(message: ["", "", "LIL SAUCE", "", ""])

            // Pause 3s (scramble ~2s + 0.5s extra viewing), then dissolve to mode picker
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
                UIView.animate(withDuration: 0.6, animations: {
                    titleBoard.alpha = 0
                }, completion: { _ in
                    titleBoard.removeFromSuperview()
                    self?.showModePicker()
                })
            }
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

        // Des-C2: Animated transition — zoom up + cross-dissolve to board (~0.8s total)
        // Set up the board behind the picker view
        startBoard(mode: mode)
        // Move picker view to front so it animates over the board
        view.bringSubviewToFront(picker.view)

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

    // MARK: - Settings Overlay (Des-C3: tvOS-native with blur, focus, parallax)

    private func showSettings() {
        // Des-C3: Use UIVisualEffectView with dark blur for background
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: nil) // Start with no effect for animation
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
        settingsOverlay = blurView

        let contentView = blurView.contentView

        // Title
        let titleLabel = UILabel()
        titleLabel.text = "SETTINGS"
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 48, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#F0E6D0")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        // Mode card buttons
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.clipsToBounds = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

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
        contentView.addSubview(sndButton)
        soundButton = sndButton

        // Hint
        let hintLabel = UILabel()
        hintLabel.text = "Navigate · Click to select · Menu to close"
        hintLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        hintLabel.textColor = UIColor(hex: "#555555")
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hintLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalToConstant: 900),
            stackView.heightAnchor.constraint(equalToConstant: 280),
            sndButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            sndButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            hintLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            hintLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])

        // Des-M4: 0.3s fade animation on show
        contentView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            blurView.effect = blurEffect
            contentView.alpha = 1
        }
    }

    private func createSettingsModeButton(mode: ModeDefinition, tag: Int, isActive: Bool) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.backgroundColor = UIColor(hex: "#2A2A2A")
        // Des-M2: unified corner radius 16pt for cards
        button.layer.cornerRadius = 16
        // Des-C3: clipsToBounds false for shadow glow visibility
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(settingsModeSelected(_:)), for: .primaryActionTriggered)

        // Des-C3: Shadow glow with mode color (replaces accent bar)
        button.layer.shadowColor = mode.color.cgColor
        button.layer.shadowRadius = 20
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .zero

        // Des-C3: Add parallax motion effect for tvOS focus
        let horizontalMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotion.minimumRelativeValue = -5
        horizontalMotion.maximumRelativeValue = 5
        let verticalMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotion.minimumRelativeValue = -5
        verticalMotion.maximumRelativeValue = 5
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotion, verticalMotion]
        button.addMotionEffect(group)

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
            activeLabel.textColor = mode.color
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
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: isActive ? -12 : 0),
        ])

        return button
    }

    @objc private func settingsModeSelected(_ sender: UIButton) {
        let mode = modes[sender.tag]
        if mode.id != currentMode {
            UserDefaults.standard.set(mode.id, forKey: modeKey)
            dismissSettings {
                self.startBoard(mode: mode.id)
            }
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

    // Des-M4: 0.3s fade animation on dismiss
    private func dismissSettings(completion: (() -> Void)? = nil) {
        guard let overlay = settingsOverlay as? UIVisualEffectView else {
            settingsOverlay?.removeFromSuperview()
            settingsOverlay = nil
            settingsButtons = []
            soundButton = nil
            completion?()
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            overlay.effect = nil
            overlay.contentView.alpha = 0
        }, completion: { _ in
            overlay.removeFromSuperview()
            self.settingsOverlay = nil
            self.settingsButtons = []
            self.soundButton = nil
            completion?()
        })
    }

    // Focus handling for settings overlay (Des-C3: stronger focus with glow)
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            // Settings mode buttons
            if let prev = context.previouslyFocusedView as? UIButton,
               self.settingsButtons.contains(prev) {
                prev.backgroundColor = UIColor(hex: "#2A2A2A")
                prev.transform = .identity
                prev.layer.shadowRadius = 20
                prev.layer.shadowOpacity = 0.3
            }
            if let next = context.nextFocusedView as? UIButton,
               self.settingsButtons.contains(next) {
                // Des-M1 style: scale, y-lift, stronger glow
                next.backgroundColor = UIColor(hex: "#3A3A3A")
                next.transform = CGAffineTransform(translationX: 0, y: -6).scaledBy(x: 1.08, y: 1.08)
                next.layer.shadowRadius = 25
                next.layer.shadowOpacity = 0.5
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
