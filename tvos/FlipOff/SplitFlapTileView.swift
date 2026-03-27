import UIKit

/// A single split-flap character tile matching the web animation:
/// rapid character scramble with cycling text colors, then a subtle perspective tilt to settle.
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
    private let splitLine = UIView()  // Cosmetic split line for the look

    private(set) var currentChar: Character = " "
    private var isAnimating = false
    private var scrambleTimer: Timer?

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
        clipsToBounds = false  // Allow slight 3D perspective overflow

        characterLabel.textAlignment = .center
        characterLabel.textColor = Self.creamColor
        characterLabel.adjustsFontSizeToFitWidth = true
        characterLabel.baselineAdjustment = .alignCenters
        characterLabel.numberOfLines = 1
        characterLabel.minimumScaleFactor = 0.5
        addSubview(characterLabel)

        // Cosmetic split line across the middle
        splitLine.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(splitLine)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 2
        characterLabel.frame = CGRect(x: inset, y: 0, width: bounds.width - inset * 2, height: bounds.height)
        splitLine.frame = CGRect(x: 0, y: bounds.height / 2 - 0.5, width: bounds.width, height: 1)
    }

    func configureFont(size: CGFloat) {
        characterLabel.font = UIFont.monospacedSystemFont(ofSize: size, weight: .bold)
    }

    // MARK: - Character Display

    func setChar(_ char: Character, color: UIColor = creamColor) {
        currentChar = char
        characterLabel.text = char == " " ? "" : String(char)
        characterLabel.textColor = color
        backgroundColor = Self.tileBgColor
        layer.transform = CATransform3DIdentity
    }

    // MARK: - Flip Animation (matches web's scrambleTo)

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

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.startScramble(target: character, completion: completion)
        }
    }

    private func startScramble(target: Character, completion: (() -> Void)?) {
        var scrambleCount = 0
        let maxScrambles = 10 + Int.random(in: 0..<4)  // 10-13 steps, matching web's 10-14
        let scrambleInterval: TimeInterval = 0.07  // 70ms, matching web exactly

        scrambleTimer?.invalidate()
        scrambleTimer = Timer.scheduledTimer(withTimeInterval: scrambleInterval, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }

            // Random character with cycling color
            let randChar = Self.charset.randomElement() ?? "A"
            let color = Self.scrambleColors[scrambleCount % Self.scrambleColors.count]

            self.characterLabel.text = randChar == " " ? "" : String(randChar)
            self.characterLabel.textColor = color
            self.backgroundColor = Self.tileBgColor  // Keep bg dark, color is on text

            scrambleCount += 1

            if scrambleCount >= maxScrambles {
                timer.invalidate()
                self.scrambleTimer = nil

                // Set final character
                let text = target == " " ? "" : String(target)
                self.characterLabel.text = text
                self.characterLabel.textColor = Self.creamColor

                // Subtle perspective tilt to settle (matching web's rotateX(-8deg))
                let flipDuration: TimeInterval = 0.15  // 150ms, matching web's FLIP_DURATION
                var perspective = CATransform3DIdentity
                perspective.m34 = -1.0 / 400.0  // Match web's perspective(400px)
                let tilt = CATransform3DRotate(perspective, -.pi / 22.5, 1, 0, 0)  // ~8 degrees

                UIView.animate(withDuration: flipDuration / 2, delay: 0, options: .curveEaseIn, animations: {
                    self.layer.transform = tilt
                }, completion: { _ in
                    UIView.animate(withDuration: flipDuration / 2, delay: 0, options: .curveEaseOut, animations: {
                        self.layer.transform = CATransform3DIdentity
                    }, completion: { _ in
                        self.currentChar = target
                        self.isAnimating = false
                        FlipSoundEngine.shared.playClick()
                        completion?()
                    })
                })
            }
        }
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

