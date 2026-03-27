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
                        print("[LilSauce] Fetch failed, retrying in \(Self.fetchRetryDelay)s (attempt \(self.fetchRetryCount)/\(Self.maxFetchRetries))")
                        DispatchQueue.main.asyncAfter(deadline: .now() + Self.fetchRetryDelay) { [weak self] in
                            guard let self = self else { return }
                            self.fetchMessages(mode: mode)
                        }
                    } else {
                        self.boardView.stopLoadingScramble()
                        self.statusLabel.text = "Could not load messages"
                        self.view.addSubview(self.statusLabel)
                        self.setupStatusLabelConstraints()
                        print("[LilSauce] Failed to fetch messages after \(Self.maxFetchRetries) retries")
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
        print("[LilSauce] Sound \(muted ? "OFF" : "ON")")
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
        button.backgroundColor = UIColor(hex: "#1A1A1A")
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(settingsModeSelected(_:)), for: .primaryActionTriggered)

        // Glass edge
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 1, alpha: 0.06).cgColor

        // Depth shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 12
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 4)

        // Top accent stripe
        let stripe = CALayer()
        stripe.backgroundColor = mode.color.cgColor
        stripe.frame = CGRect(x: 0, y: 0, width: 400, height: 3)
        button.layer.addSublayer(stripe)

        // Parallax motion
        let hMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        hMotion.minimumRelativeValue = -5
        hMotion.maximumRelativeValue = 5
        let vMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vMotion.minimumRelativeValue = -5
        vMotion.maximumRelativeValue = 5
        let group = UIMotionEffectGroup()
        group.motionEffects = [hMotion, vMotion]
        button.addMotionEffect(group)

        // Icon
        let icons = ["🎲", "💡", "🏛"]
        let iconLabel = UILabel()
        iconLabel.text = tag < icons.count ? icons[tag] : "●"
        iconLabel.font = UIFont.systemFont(ofSize: 32)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.isUserInteractionEnabled = false
        button.addSubview(iconLabel)

        // Title
        let label = UILabel()
        label.text = mode.title
        label.font = UIFont.monospacedSystemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(hex: "#F0E6D0")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        button.addSubview(label)

        // Active indicator
        if isActive {
            let activeLabel = UILabel()
            activeLabel.text = "● CURRENT"
            activeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            activeLabel.textColor = mode.color
            activeLabel.textAlignment = .center
            activeLabel.translatesAutoresizingMaskIntoConstraints = false
            activeLabel.isUserInteractionEnabled = false
            button.addSubview(activeLabel)

            // Active glow
            button.layer.shadowColor = mode.color.cgColor
            button.layer.shadowRadius = 16
            button.layer.shadowOpacity = 0.3

            NSLayoutConstraint.activate([
                activeLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
                activeLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            ])
        }

        // Accessibility
        let activeText = isActive ? ". Currently selected" : ""
        button.accessibilityLabel = "\(mode.title) mode\(activeText)"

        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: isActive ? -40 : -24),

            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
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
        print("[LilSauce] Sound \(muted ? "OFF" : "ON")")
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

    // Focus handling for settings overlay
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            // Settings mode buttons — unfocus
            if let prev = context.previouslyFocusedView as? UIButton,
               self.settingsButtons.contains(prev) {
                prev.backgroundColor = UIColor(hex: "#1A1A1A")
                prev.transform = .identity
                prev.layer.borderColor = UIColor(white: 1, alpha: 0.06).cgColor
                prev.layer.shadowColor = UIColor.black.cgColor
                prev.layer.shadowRadius = 12
                prev.layer.shadowOpacity = 0.5
                prev.layer.shadowOffset = CGSize(width: 0, height: 4)
            }
            // Settings mode buttons — focus
            if let next = context.nextFocusedView as? UIButton,
               self.settingsButtons.contains(next) {
                next.backgroundColor = UIColor(hex: "#222222")
                next.transform = CGAffineTransform(translationX: 0, y: -8).scaledBy(x: 1.05, y: 1.05)
                next.layer.borderColor = UIColor(white: 1, alpha: 0.12).cgColor
                let tag = next.tag
                if tag < self.modes.count {
                    next.layer.shadowColor = self.modes[tag].color.cgColor
                    next.layer.shadowRadius = 20
                    next.layer.shadowOpacity = 0.4
                    next.layer.shadowOffset = CGSize(width: 0, height: 6)
                }
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
