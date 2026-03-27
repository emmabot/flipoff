import UIKit

/// A single split-flap character tile matching the web animation:
/// rapid character scramble with cycling background colors, then a subtle perspective tilt to settle.
class SplitFlapTileView: UIView {

    // MARK: - Constants

    static let scrambleColors: [UIColor] = [
        UIColor(hex: "#E8A840"), UIColor(hex: "#D4735E"), UIColor(hex: "#6BA3BE"),
        UIColor(hex: "#7BA068"), UIColor(hex: "#E8DCC8"), UIColor(hex: "#9B8EC4")
    ]
    static let creamColor = UIColor(hex: "#F0E6D0")          // P1: matched web cream
    static let tileBgColor = UIColor(hex: "#2A2A2A")
    static let charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,-!?'/: "

    // MARK: - Layers & Subviews

    private let bgGradient = CAGradientLayer()                // P2: subtle tile gradient
    private let characterLabel = UILabel()
    private let splitLine = UIView()
    private let lightLine = UIView()                          // P2: light catch below split
    private let shadowOverlay = CAGradientLayer()             // P1: inner shadow for depth
    private let highlightLayer = CAGradientLayer()            // P2: metallic highlight

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
        backgroundColor = .clear                               // P2: gradient replaces flat bg
        layer.cornerRadius = 4                                 // P1: increased from 2
        clipsToBounds = true                                   // Clip gradient to rounded corners

        // P1: outer bezel border
        layer.borderWidth = 1
        layer.borderColor = UIColor(white: 0, alpha: 0.5).cgColor

        // --- Layer ordering (back → front) ---

        // 1. Background gradient (P2)
        bgGradient.colors = [
            UIColor(hex: "#2E2E2E").cgColor,
            UIColor(hex: "#262626").cgColor
        ]
        bgGradient.frame = bounds
        layer.insertSublayer(bgGradient, at: 0)

        // 2. Character label (subview)
        characterLabel.textAlignment = .center
        characterLabel.textColor = Self.creamColor
        characterLabel.adjustsFontSizeToFitWidth = true
        characterLabel.baselineAdjustment = .alignCenters
        characterLabel.numberOfLines = 1
        characterLabel.minimumScaleFactor = 0.5
        addSubview(characterLabel)

        // 3. Split line (P2: thicker)
        splitLine.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(splitLine)

        // 4. Light catch below split (P2)
        lightLine.backgroundColor = UIColor(white: 1, alpha: 0.03)
        addSubview(lightLine)

        // 5. Inner shadow overlay (P1: depth)
        shadowOverlay.colors = [
            UIColor(white: 0, alpha: 0.3).cgColor,
            UIColor(white: 0, alpha: 0.0).cgColor,
            UIColor(white: 0, alpha: 0.0).cgColor,
            UIColor(white: 1, alpha: 0.02).cgColor
        ]
        shadowOverlay.locations = [0, 0.08, 0.92, 1.0]
        shadowOverlay.frame = bounds
        layer.addSublayer(shadowOverlay)

        // 6. Metallic highlight (P2: visible during scramble only)
        highlightLayer.colors = [
            UIColor.clear.cgColor,
            UIColor(white: 1, alpha: 0.08).cgColor,
            UIColor(white: 1, alpha: 0.15).cgColor,
            UIColor(white: 1, alpha: 0.08).cgColor,
            UIColor.clear.cgColor
        ]
        highlightLayer.locations = [0, 0.45, 0.5, 0.55, 1.0]
        highlightLayer.frame = bounds
        highlightLayer.opacity = 0
        layer.addSublayer(highlightLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 2
        characterLabel.frame = CGRect(x: inset, y: 0, width: bounds.width - inset * 2, height: bounds.height)

        // P2: thicker split line
        splitLine.frame = CGRect(x: 0, y: bounds.height / 2 - 0.75, width: bounds.width, height: 1.5)
        lightLine.frame = CGRect(x: 0, y: bounds.height / 2 + 0.75, width: bounds.width, height: 1)

        // Resize CALayers
        bgGradient.frame = bounds
        shadowOverlay.frame = bounds
        highlightLayer.frame = bounds
    }

    func configureFont(size: CGFloat) {
        characterLabel.font = UIFont.monospacedSystemFont(ofSize: size, weight: .bold)
    }

    // MARK: - Character Display

    func setChar(_ char: Character, color: UIColor = creamColor) {
        currentChar = char
        characterLabel.text = char == " " ? "" : String(char)
        characterLabel.textColor = color
        // Restore gradient bg
        bgGradient.isHidden = false
        backgroundColor = .clear
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
        let maxScrambles = 10 + Int.random(in: 0..<4)
        let scrambleInterval: TimeInterval = 0.07

        // P2: show metallic highlight during scramble
        highlightLayer.opacity = 1

        scrambleTimer?.invalidate()
        scrambleTimer = Timer.scheduledTimer(withTimeInterval: scrambleInterval, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }

            let randChar = Self.charset.randomElement() ?? "A"
            let color = Self.scrambleColors[scrambleCount % Self.scrambleColors.count]

            self.characterLabel.text = randChar == " " ? "" : String(randChar)

            // P0: color the BACKGROUND, not the text
            self.bgGradient.isHidden = true
            self.backgroundColor = color
            self.characterLabel.textColor = .white

            scrambleCount += 1

            if scrambleCount >= maxScrambles {
                timer.invalidate()
                self.scrambleTimer = nil

                // Set final character — reset colors
                let text = target == " " ? "" : String(target)
                self.characterLabel.text = text
                self.characterLabel.textColor = Self.creamColor
                self.bgGradient.isHidden = false
                self.backgroundColor = .clear

                // P2: fade out metallic highlight
                let fadeOut = CABasicAnimation(keyPath: "opacity")
                fadeOut.fromValue = 1
                fadeOut.toValue = 0
                fadeOut.duration = 0.15
                self.highlightLayer.add(fadeOut, forKey: "fadeOut")
                self.highlightLayer.opacity = 0

                // Subtle perspective tilt to settle
                let flipDuration: TimeInterval = 0.15
                var perspective = CATransform3DIdentity
                perspective.m34 = -1.0 / 400.0
                let tilt = CATransform3DRotate(perspective, -.pi / 22.5, 1, 0, 0)

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

