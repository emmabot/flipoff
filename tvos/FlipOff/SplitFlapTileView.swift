import UIKit
import QuartzCore

/// A single split-flap character tile with top/bottom halves and 3D flip animation.
class SplitFlapTileView: UIView {

    // MARK: - Constants

    static let scrambleColors: [UIColor] = [
        UIColor(hex: "#E8DCC8"), UIColor(hex: "#C4A35A"), UIColor(hex: "#8B8C5E"),
        UIColor(hex: "#B85C38"), UIColor(hex: "#6B7F99"), UIColor(hex: "#D4CFC4")
    ]
    static let creamColor = UIColor(hex: "#E8DCC8")
    static let tileBgColor = UIColor(hex: "#2A2A2A")
    static let charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,-!?'/: "

    // MARK: - Subviews

    private let topHalf = UIView()
    private let bottomHalf = UIView()
    private let topLabel = UILabel()
    private let bottomLabel = UILabel()
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

        for half in [topHalf, bottomHalf] {
            half.backgroundColor = Self.tileBgColor
            half.clipsToBounds = true
            half.translatesAutoresizingMaskIntoConstraints = false
            addSubview(half)
        }

        splitLine.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        splitLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(splitLine)

        for label in [topLabel, bottomLabel] {
            label.textAlignment = .center
            label.textColor = Self.creamColor
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
        }

        topHalf.addSubview(topLabel)
        bottomHalf.addSubview(bottomLabel)

        NSLayoutConstraint.activate([
            topHalf.topAnchor.constraint(equalTo: topAnchor),
            topHalf.leadingAnchor.constraint(equalTo: leadingAnchor),
            topHalf.trailingAnchor.constraint(equalTo: trailingAnchor),
            topHalf.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),

            bottomHalf.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomHalf.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomHalf.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomHalf.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),

            splitLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            splitLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            splitLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            splitLine.heightAnchor.constraint(equalToConstant: 1),

            topLabel.centerXAnchor.constraint(equalTo: topHalf.centerXAnchor),
            topLabel.bottomAnchor.constraint(equalTo: topHalf.bottomAnchor, constant: 0),
            topLabel.leadingAnchor.constraint(equalTo: topHalf.leadingAnchor, constant: 1),
            topLabel.trailingAnchor.constraint(equalTo: topHalf.trailingAnchor, constant: -1),

            bottomLabel.centerXAnchor.constraint(equalTo: bottomHalf.centerXAnchor),
            bottomLabel.topAnchor.constraint(equalTo: bottomHalf.topAnchor, constant: 0),
            bottomLabel.leadingAnchor.constraint(equalTo: bottomHalf.leadingAnchor, constant: 1),
            bottomLabel.trailingAnchor.constraint(equalTo: bottomHalf.trailingAnchor, constant: -1),
        ])
    }

    func configureFont(size: CGFloat) {
        let font = UIFont(name: "Menlo-Bold", size: size)
            ?? .monospacedSystemFont(ofSize: size, weight: .bold)
        topLabel.font = font
        bottomLabel.font = font
    }

    // MARK: - Character Display

    func setChar(_ char: Character, color: UIColor = creamColor) {
        currentChar = char
        let text = char == " " ? "" : String(char)
        topLabel.text = text
        bottomLabel.text = text
        topLabel.textColor = color
        bottomLabel.textColor = color
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

        let scrambleCount = 10 + Int.random(in: 0..<4)
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
            // Final flip to target character
            performFlipAnimation(to: target) { [weak self] in
                self?.isAnimating = false
                completion?()
            }
            return
        }

        // Random character + cycling color
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
        let duration: TimeInterval = 0.025

        // Phase 1: Rotate top half down (hide it)
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        let rotated = CATransform3DRotate(perspective, .pi / 2, 1, 0, 0)

        CATransaction.begin()
        CATransaction.setDisableActions(false)
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self else { return }
            // Swap character while top half is hidden
            self.setChar(char, color: color)

            // Phase 2: Rotate top half back to normal
            CATransaction.begin()
            CATransaction.setAnimationDuration(duration)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
            CATransaction.setCompletionBlock {
                completion?()
            }
            self.topHalf.layer.transform = CATransform3DIdentity
            CATransaction.commit()
        }

        topHalf.layer.transform = rotated
        CATransaction.commit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Set anchor point at bottom of top half for rotation
        topHalf.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        // Compensate for anchor point shift
        topHalf.layer.position = CGPoint(x: bounds.midX, y: bounds.midY)
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

