import UIKit

protocol ModePickerDelegate: AnyObject {
    func modePicker(_ picker: ModePickerViewController, didSelect mode: String)
}

class ModePickerViewController: UIViewController {
    weak var delegate: ModePickerDelegate?

    private let modes = ModeDefinition.all
    private var modeButtons: [UIButton] = []

    // Card icon labels for styling during focus
    private var iconLabels: [UILabel] = []
    // Accent stripe layers per card
    private var accentStripes: [CALayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        // Depth gradient background — matches board aesthetic
        let bgGradient = CAGradientLayer()
        bgGradient.colors = [
            UIColor(hex: "#0d0d0d").cgColor,
            UIColor(hex: "#080808").cgColor,
            UIColor.black.cgColor
        ]
        bgGradient.locations = [0, 0.5, 1]
        bgGradient.frame = view.bounds
        view.layer.insertSublayer(bgGradient, at: 0)

        // Title: "LIL SAUCE" — large monospaced, cream on black
        let titleLabel = UILabel()
        // P2: Kern (letter-spacing) for premium hardware-label feel
        let titleAttr = NSAttributedString(string: "LIL SAUCE", attributes: [
            .font: UIFont.monospacedSystemFont(ofSize: 72, weight: .bold),
            .foregroundColor: UIColor(hex: "#F0E6D0"),
            .kern: 12.0
        ])
        titleLabel.attributedText = titleAttr
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Subtitle — readable contrast (≥ 4.5:1 on #0d0d0d)
        let subtitleLabel = UILabel()
        subtitleLabel.text = "PICK YOUR FLAVOR"
        subtitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        subtitleLabel.textColor = UIColor(hex: "#888888")
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        // Tracking for that hardware-label feel
        subtitleLabel.attributedText = NSAttributedString(
            string: "PICK YOUR FLAVOR",
            attributes: [
                .kern: 6.0,
                .font: UIFont.systemFont(ofSize: 28, weight: .medium),
                .foregroundColor: UIColor(hex: "#888888")
            ]
        )
        view.addSubview(subtitleLabel)

        // Card container
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = false
        view.addSubview(stackView)

        modeButtons = []
        iconLabels = []
        accentStripes = []
        for (i, mode) in modes.enumerated() {
            let button = createModeButton(mode: mode, tag: i)
            stackView.addArrangedSubview(button)
            modeButtons.append(button)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 64),
            stackView.widthAnchor.constraint(equalToConstant: 1100),
            stackView.heightAnchor.constraint(equalToConstant: 360)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Keep background gradient sized to view
        if let bgLayer = view.layer.sublayers?.first as? CAGradientLayer {
            bgLayer.frame = view.bounds
        }
    }

    // MARK: - Card Creation

    private func createModeButton(mode: ModeDefinition, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.backgroundColor = UIColor(hex: "#1A1A1A")
        button.layer.cornerRadius = 20
        button.clipsToBounds = true  // Clip the accent stripe inside the card
        button.layer.masksToBounds = false  // But allow shadow outside
        button.addTarget(self, action: #selector(modeSelected(_:)), for: .primaryActionTriggered)

        // Subtle border — glass edge
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor(white: 1, alpha: 0.06).cgColor

        // Default shadow — subtle depth, not color glow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 16
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 4)

        // Top accent stripe — 3pt colored bar at card top edge
        let stripe = CALayer()
        stripe.backgroundColor = mode.color.cgColor
        stripe.frame = CGRect(x: 0, y: 0, width: 400, height: 3) // Width updated in layoutSubviews
        button.layer.addSublayer(stripe)
        accentStripes.append(stripe)

        // Icon — large emoji/symbol for visual identity
        let iconLabel = UILabel()
        let icons = ["🎲", "💡", "🏛"]
        iconLabel.text = tag < icons.count ? icons[tag] : "●"
        iconLabel.font = UIFont.systemFont(ofSize: 48)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.isUserInteractionEnabled = false
        button.addSubview(iconLabel)
        iconLabels.append(iconLabel)

        // Title — mode name
        let titleLabel = UILabel()
        titleLabel.text = mode.title
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 36, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#F0E6D0")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = false
        button.addSubview(titleLabel)

        // Description — what's in this mode
        let descLabel = UILabel()
        descLabel.text = mode.description
        descLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        descLabel.textColor = UIColor(hex: "#999999")
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.isUserInteractionEnabled = false
        button.addSubview(descLabel)

        // Accessibility
        button.accessibilityLabel = "\(mode.title) mode. \(mode.description.replacingOccurrences(of: "\n", with: ", "))"

        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            iconLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 48),

            titleLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 16),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 24),
            descLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -24)
        ])

        // Update stripe width after layout
        button.layoutIfNeeded()

        return button
    }

    // Ensure accent stripe width matches card width
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for (i, button) in modeButtons.enumerated() {
            if i < accentStripes.count {
                accentStripes[i].frame = CGRect(x: 0, y: 0, width: button.bounds.width, height: 3)
            }
        }
    }

    @objc private func modeSelected(_ sender: UIButton) {
        let mode = modes[sender.tag]
        delegate?.modePicker(self, didSelect: mode.id)
    }

    // MARK: - Focus

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            // Unfocus previous
            if let prev = context.previouslyFocusedView as? UIButton,
               self.modeButtons.contains(prev) {
                prev.backgroundColor = UIColor(hex: "#1A1A1A")
                prev.transform = .identity
                prev.layer.borderColor = UIColor(white: 1, alpha: 0.06).cgColor
                prev.layer.shadowColor = UIColor.black.cgColor
                prev.layer.shadowRadius = 16
                prev.layer.shadowOpacity = 0.6
                prev.layer.shadowOffset = CGSize(width: 0, height: 4)
            }
            // Focus next
            if let next = context.nextFocusedView as? UIButton,
               self.modeButtons.contains(next) {
                let tag = next.tag
                // Lift + subtle scale
                next.backgroundColor = UIColor(hex: "#222222")
                next.transform = CGAffineTransform(translationX: 0, y: -10).scaledBy(x: 1.05, y: 1.05)
                // Glass border brightens
                next.layer.borderColor = UIColor(white: 1, alpha: 0.12).cgColor
                // Colored shadow glow from mode accent
                if tag < self.modes.count {
                    next.layer.shadowColor = self.modes[tag].color.cgColor
                    next.layer.shadowRadius = 24
                    next.layer.shadowOpacity = 0.5
                    next.layer.shadowOffset = CGSize(width: 0, height: 8)
                }
            }
        }, completion: nil)
    }
}

