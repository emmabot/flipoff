import UIKit

/// A single split-flap character tile with a real two-half 3D flip animation.
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

    /// Static top half — shows top of current char, then new char once flap lifts
    private let topHalfView = UIView()
    /// Static bottom half — shows bottom of current char, updates mid-flip
    private let bottomHalfView = UIView()
    /// Animated flap — clips to top half, rotates around bottom edge
    private let flapView = UIView()

    /// Full-size labels inside each clipping view
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
    private let flapLabel = UILabel()

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

    private func configureLabel(_ label: UILabel) {
        label.textAlignment = .center
        label.textColor = Self.creamColor
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.5
    }

    private func setupTile() {
        backgroundColor = Self.tileBgColor
        layer.cornerRadius = 2
        clipsToBounds = true

        // Top half — clips to upper 50%
        topHalfView.clipsToBounds = true
        topHalfView.backgroundColor = Self.tileBgColor
        addSubview(topHalfView)

        configureLabel(topLabel)
        topHalfView.addSubview(topLabel)

        // Bottom half — clips to lower 50%
        bottomHalfView.clipsToBounds = true
        bottomHalfView.backgroundColor = Self.tileBgColor
        addSubview(bottomHalfView)

        configureLabel(bottomLabel)
        bottomHalfView.addSubview(bottomLabel)

        // Flap — same size as top half, animates over it
        flapView.clipsToBounds = true
        flapView.backgroundColor = Self.tileBgColor
        flapView.isHidden = true
        addSubview(flapView)

        configureLabel(flapLabel)
        flapView.addSubview(flapLabel)

        // Cosmetic split line on top of everything
        splitLine.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(splitLine)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let w = bounds.width
        let h = bounds.height
        let halfH = h / 2

        topHalfView.frame = CGRect(x: 0, y: 0, width: w, height: halfH)
        bottomHalfView.frame = CGRect(x: 0, y: halfH, width: w, height: halfH)
        flapView.frame = CGRect(x: 0, y: 0, width: w, height: halfH)

        // Labels are full tile height with 2pt horizontal insets so chars don't touch edges
        let inset: CGFloat = 2
        topLabel.frame = CGRect(x: inset, y: 0, width: w - inset * 2, height: h)
        flapLabel.frame = CGRect(x: inset, y: 0, width: w - inset * 2, height: h)
        // Bottom label offset up so lower half of text is visible
        bottomLabel.frame = CGRect(x: inset, y: -halfH, width: w - inset * 2, height: h)

        splitLine.frame = CGRect(x: 0, y: halfH - 0.5, width: w, height: 1)

        // Reset flap anchor/position for correct hinge
        flapView.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        flapView.layer.position = CGPoint(x: w / 2, y: halfH)
    }

    func configureFont(size: CGFloat) {
        let font = UIFont.monospacedSystemFont(ofSize: size, weight: .bold)
        topLabel.font = font
        bottomLabel.font = font
        flapLabel.font = font
    }

    // MARK: - Character Display

    func setChar(_ char: Character, color: UIColor = creamColor) {
        currentChar = char
        let text = char == " " ? "" : String(char)
        topLabel.text = text
        topLabel.textColor = color
        bottomLabel.text = text
        bottomLabel.textColor = color
        flapView.isHidden = true
        flapView.layer.transform = CATransform3DIdentity
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

        let scrambleCount = 1 + Int.random(in: 0..<2)
        let scrambleInterval: TimeInterval = 0.015
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

        // Quick character swap without full 3D animation
        let text = randChar == " " ? "" : String(randChar)
        topLabel.text = text
        topLabel.textColor = color
        bottomLabel.text = text
        bottomLabel.textColor = color

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.runScramble(step: step + 1, total: total, interval: interval,
                             target: target, completion: completion)
        }
    }

    private func performFlipAnimation(to char: Character, color: UIColor = creamColor,
                                       fast: Bool = false, completion: (() -> Void)? = nil) {
        let firstDuration: TimeInterval = fast ? 0.02 : 0.06
        let secondDuration: TimeInterval = fast ? 0.02 : 0.05
        let text = char == " " ? "" : String(char)

        // 1. Flap shows current character (top half)
        let currentText = currentChar == " " ? "" : String(currentChar)
        flapLabel.text = currentText
        flapLabel.textColor = topLabel.textColor
        flapView.layer.transform = CATransform3DIdentity
        flapView.isHidden = false

        // 2. Behind the flap: set top half to NEW character
        topLabel.text = text
        topLabel.textColor = color

        // 3. Perspective transform
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0

        // 4. Animate flap rotating forward: 0 → -90° around X axis
        UIView.animate(withDuration: firstDuration, delay: 0, options: .curveEaseIn, animations: {
            self.flapView.layer.transform = CATransform3DRotate(perspective, -.pi / 2, 1, 0, 0)
        }, completion: { _ in
            // 5. Mid-flip: update bottom half to new character
            self.bottomLabel.text = text
            self.bottomLabel.textColor = color

            // 6. Flap now shows new char (back side), starts at +90°
            self.flapLabel.text = text
            self.flapLabel.textColor = color
            self.flapView.layer.transform = CATransform3DRotate(perspective, .pi / 2, 1, 0, 0)

            // 7. Animate flap settling: 90° → 0
            UIView.animate(withDuration: secondDuration, delay: 0, options: .curveEaseOut, animations: {
                self.flapView.layer.transform = CATransform3DIdentity
            }, completion: { _ in
                // 8. Sync final state
                self.flapView.isHidden = true
                self.currentChar = char
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

