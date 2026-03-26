import UIKit

/// A single split-flap character tile with a cosmetic split line and scale-Y flip animation.
class SplitFlapTileView: UIView {

    // MARK: - Constants

    static let scrambleColors: [UIColor] = [
        UIColor(hex: "#E8A840"), UIColor(hex: "#D4735E"), UIColor(hex: "#6BA3BE"),
        UIColor(hex: "#7BA068"), UIColor(hex: "#E8DCC8"), UIColor(hex: "#9B8EC4")
    ]
    static let creamColor = UIColor(hex: "#E8DCC8")
    static let tileBgColor = UIColor(hex: "#2A2A2A")
    static let charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,-!?'/: "

    // MARK: - Subviews

    private let characterLabel = UILabel()
    private let splitLine = UIView()

    private(set) var currentChar: Character = " "
    private var isAnimating = false

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTile()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTile()
    }

    private func setupTile() {
        backgroundColor = Self.tileBgColor
        layer.cornerRadius = 2
        clipsToBounds = true

        // Single character label — full tile size, centered
        characterLabel.textAlignment = .center
        characterLabel.textColor = Self.creamColor
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        characterLabel.adjustsFontSizeToFitWidth = true
        characterLabel.baselineAdjustment = .alignCenters
        characterLabel.numberOfLines = 1
        characterLabel.minimumScaleFactor = 0.5
        addSubview(characterLabel)

        // Cosmetic split line overlay at vertical center
        splitLine.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        splitLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(splitLine)

        NSLayoutConstraint.activate([
            characterLabel.topAnchor.constraint(equalTo: topAnchor),
            characterLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            characterLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            characterLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            splitLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            splitLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            splitLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            splitLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    func configureFont(size: CGFloat) {
        let font = UIFont(name: "Menlo-Bold", size: size)
            ?? .monospacedSystemFont(ofSize: size, weight: .bold)
        characterLabel.font = font
    }

    // MARK: - Character Display

    func setChar(_ char: Character, color: UIColor = creamColor) {
        currentChar = char
        characterLabel.text = char == " " ? "" : String(char)
        characterLabel.textColor = color
    }

    // MARK: - Flip Animation

    func flip(to character: Character, delay: TimeInterval = 0, completion: (() -> Void)? = nil) {
        guard character != currentChar else {
            completion?()
            return
        }
        guard !isAnimating else {
            completion?()
            return
        }
        isAnimating = true

        let scrambleCount = 5 + Int.random(in: 0..<3)
        let scrambleInterval: TimeInterval = 0.035
        let targetChar = character

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.runScramble(step: 0, total: scrambleCount, interval: scrambleInterval,
                             target: targetChar, completion: completion)
        }
    }

    private func runScramble(step: Int, total: Int, interval: TimeInterval,
                             target: Character, completion: (() -> Void)?) {
        if step >= total {
            performFlipAnimation(to: target) { [weak self] in
                self?.isAnimating = false
                completion?()
            }
            return
        }

        let randChar = Self.charset.randomElement() ?? "A"
        let color = Self.scrambleColors[step % Self.scrambleColors.count]

        performFlipAnimation(to: randChar, color: color) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                self?.runScramble(step: step + 1, total: total, interval: interval,
                                 target: target, completion: completion)
            }
        }
    }

    private func performFlipAnimation(to char: Character, color: UIColor = creamColor,
                                       completion: (() -> Void)? = nil) {
        // Scale-Y squish to simulate a flap
        UIView.animate(withDuration: 0.08, animations: {
            self.characterLabel.transform = CGAffineTransform(scaleX: 1, y: 0.01)
        }, completion: { _ in
            self.setChar(char, color: color)
            UIView.animate(withDuration: 0.08, animations: {
                self.characterLabel.transform = .identity
            }, completion: { _ in
                completion?()
            })
        })
    }
}

// MARK: - UIColor Hex Extension

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

