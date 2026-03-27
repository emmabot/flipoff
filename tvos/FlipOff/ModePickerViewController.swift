import UIKit

protocol ModePickerDelegate: AnyObject {
    func modePicker(_ picker: ModePickerViewController, didSelect mode: String)
}

class ModePickerViewController: UIViewController {
    weak var delegate: ModePickerDelegate?

    private let modes = ModeDefinition.all
    private var modeButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#1A1A1A")
        setupUI()
    }

    private func setupUI() {
        // Title: "LIL SAUCE" in monospaced
        let titleLabel = UILabel()
        titleLabel.text = "LIL SAUCE"
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 64, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#F0E6D0")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Subtitle (Des-C1: "pick your flavor" fits the sauce metaphor)
        let subtitleLabel = UILabel()
        subtitleLabel.text = "pick your flavor"
        subtitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .regular)
        subtitleLabel.textColor = UIColor(hex: "#666666")
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        // Card container
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 50
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        // Des-C1: clipsToBounds = false so glow shadows are visible
        stackView.clipsToBounds = false
        view.addSubview(stackView)

        modeButtons = []
        for (i, mode) in modes.enumerated() {
            let button = createModeButton(mode: mode, tag: i)
            stackView.addArrangedSubview(button)
            modeButtons.append(button)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            stackView.widthAnchor.constraint(equalToConstant: 1100),
            // Des-C1: card height 340pt minimum
            stackView.heightAnchor.constraint(equalToConstant: 340)
        ])
    }

    private func createModeButton(mode: ModeDefinition, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.tag = tag
        button.backgroundColor = UIColor(hex: "#2A2A2A")
        // Des-M2: unified corner radius 16pt for cards
        button.layer.cornerRadius = 16
        button.clipsToBounds = false
        button.addTarget(self, action: #selector(modeSelected(_:)), for: .primaryActionTriggered)

        // Des-C1: Replace thin accent bar with shadow glow
        button.layer.shadowColor = mode.color.cgColor
        button.layer.shadowRadius = 30
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = .zero

        // Title
        let titleLabel = UILabel()
        titleLabel.text = mode.title
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = UIColor(hex: "#F0E6D0")
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isUserInteractionEnabled = false
        button.addSubview(titleLabel)

        // Des-C1: Description at 28pt, color #AAAAAA
        let descLabel = UILabel()
        descLabel.text = mode.description
        descLabel.font = UIFont.systemFont(ofSize: 28, weight: .regular)
        descLabel.textColor = UIColor(hex: "#AAAAAA")
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.isUserInteractionEnabled = false
        button.addSubview(descLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: -30),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
        ])

        return button
    }

    @objc private func modeSelected(_ sender: UIButton) {
        let mode = modes[sender.tag]
        delegate?.modePicker(self, didSelect: mode.id)
    }

    // MARK: - Focus (Des-M1: stronger focus effect)

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if let prev = context.previouslyFocusedView as? UIButton,
               self.modeButtons.contains(prev) {
                prev.backgroundColor = UIColor(hex: "#2A2A2A")
                prev.transform = .identity
                // Reset shadow to default glow
                let tag = prev.tag
                if tag < self.modes.count {
                    prev.layer.shadowRadius = 30
                    prev.layer.shadowOpacity = 0.4
                }
            }
            if let next = context.nextFocusedView as? UIButton,
               self.modeButtons.contains(next) {
                // Des-M1: scale 1.08x, y-lift -8, bg #3A3A3A
                next.backgroundColor = UIColor(hex: "#3A3A3A")
                next.transform = CGAffineTransform(translationX: 0, y: -8).scaledBy(x: 1.08, y: 1.08)
                // Des-M1: shadow glow with mode color, radius 25, opacity 0.5
                let tag = next.tag
                if tag < self.modes.count {
                    next.layer.shadowColor = self.modes[tag].color.cgColor
                    next.layer.shadowRadius = 25
                    next.layer.shadowOpacity = 0.5
                }
            }
        }, completion: nil)
    }
}

