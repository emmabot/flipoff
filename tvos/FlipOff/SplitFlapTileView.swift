import UIKit

/// A single split-flap character tile with real 3D flap rotation,
/// time-slot-aware scramble colors, idle breathing, and physical depth.
class SplitFlapTileView: UIView {

    // MARK: - Constants

    static let scrambleColors: [UIColor] = [
        UIColor(hex: "#E8A840"), UIColor(hex: "#D4735E"), UIColor(hex: "#6BA3BE"),
        UIColor(hex: "#7BA068"), UIColor(hex: "#E8DCC8"), UIColor(hex: "#9B8EC4")
    ]

    // Des-D4: Time-slot-aware scramble palettes
    static let morningScrambleColors: [UIColor] = [
        UIColor(hex: "#E8A840"), UIColor(hex: "#F5C34B"), UIColor(hex: "#E8915A"),
        UIColor(hex: "#F2D98E"), UIColor(hex: "#D4735E"), UIColor(hex: "#FFD6A0")
    ]
    static let bedtimeScrambleColors: [UIColor] = [
        UIColor(hex: "#3B5998"), UIColor(hex: "#6B5B95"), UIColor(hex: "#4A6FA5"),
        UIColor(hex: "#7B68AE"), UIColor(hex: "#5C6BC0"), UIColor(hex: "#9B8EC4")
    ]

    static let creamColor = UIColor(hex: "#F0E6D0")
    static let tileBgColor = UIColor(hex: "#222222")  // Mid-value of gradient
    static let charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,-!?'/: "

    // Animation constants
    private static let scrambleBaseCount = 10
    private static let scrambleRandomRange = 0..<4
    private static let scrambleStepInterval: TimeInterval = 0.07
    private static let tiltPerspective: CGFloat = -1.0 / 400.0
    private static let highlightFadeDuration: TimeInterval = 0.15

    /// Current time slot for scramble palette selection (set by MessageScheduler)
    static var currentTimeSlot: String = "default"

    // MARK: - Layers & Subviews

    private let bgGradient = CAGradientLayer()
    private let scrambleColorLayer = CALayer()                 // Des-M5: color sublayer
    private let characterLabel = UILabel()
    private let splitLine = UIView()
    private let lightLine = UIView()
    private let shadowOverlay = CAGradientLayer()
    private let highlightLayer = CAGradientLayer()

    private(set) var currentChar: Character = " "
    private var isAnimating = false
    private var scrambleTimer: Timer?
    private var lastScrambleChar: Character = " "              // Des-D3: avoid repeats
    private var breathingAnimation: CABasicAnimation?          // Des-D1: idle breathing

    /// Des-A3: Column index for spatial audio panning (set by board view)
    var columnIndex: Int = 0
    var totalColumns: Int = 22

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
        backgroundColor = UIColor(hex: "#0A0A0A")               // Housing channel bg (matches web)
        layer.cornerRadius = 3
        clipsToBounds = false                                   // Allow shadow to render outside

        // Subtle top-edge highlight on housing (glass light catch)
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(white: 1, alpha: 0.04).cgColor

        // Outer shadow — tile sits proud of the board
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.6

        // --- Layer ordering (back → front) ---

        // 1. Background gradient — 4-stop to match web (upper/lower flap catch light differently)
        bgGradient.colors = [
            UIColor(hex: "#2A2A2A").cgColor,  // top — brightest
            UIColor(hex: "#222222").cgColor,  // just above seam
            UIColor(hex: "#1D1D1D").cgColor,  // just below seam — darkest
            UIColor(hex: "#202020").cgColor   // bottom
        ]
        bgGradient.locations = [0, 0.48, 0.52, 1.0]
        bgGradient.cornerRadius = 3
        bgGradient.masksToBounds = true
        bgGradient.frame = bounds
        layer.insertSublayer(bgGradient, at: 0)

        // Des-M5: Color sublayer for scramble (between gradient and shadow overlay)
        scrambleColorLayer.frame = bounds
        scrambleColorLayer.cornerRadius = 3
        scrambleColorLayer.masksToBounds = true
        scrambleColorLayer.isHidden = true
        layer.insertSublayer(scrambleColorLayer, above: bgGradient)

        // 2. Character label (subview)
        characterLabel.textAlignment = .center
        characterLabel.textColor = Self.creamColor
        characterLabel.adjustsFontSizeToFitWidth = true
        characterLabel.baselineAdjustment = .alignCenters
        characterLabel.numberOfLines = 1
        characterLabel.minimumScaleFactor = 0.5
        addSubview(characterLabel)

        // 3. Split line — mechanical seam (matches web at 0.55)
        splitLine.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        addSubview(splitLine)

        // 4. Light catch below split (subtle light edge)
        lightLine.backgroundColor = UIColor(white: 1, alpha: 0.03)
        addSubview(lightLine)

        // 5. Inner shadow overlay (depth)
        shadowOverlay.colors = [
            UIColor(white: 0, alpha: 0.3).cgColor,
            UIColor(white: 0, alpha: 0.0).cgColor,
            UIColor(white: 0, alpha: 0.0).cgColor,
            UIColor(white: 1, alpha: 0.02).cgColor
        ]
        shadowOverlay.locations = [0, 0.08, 0.92, 1.0]
        shadowOverlay.cornerRadius = 3
        shadowOverlay.masksToBounds = true
        shadowOverlay.frame = bounds
        layer.addSublayer(shadowOverlay)

        // 6. Metallic highlight (visible during scramble only)
        highlightLayer.colors = [
            UIColor.clear.cgColor,
            UIColor(white: 1, alpha: 0.08).cgColor,
            UIColor(white: 1, alpha: 0.15).cgColor,
            UIColor(white: 1, alpha: 0.08).cgColor,
            UIColor.clear.cgColor
        ]
        highlightLayer.locations = [0, 0.45, 0.5, 0.55, 1.0]
        highlightLayer.cornerRadius = 3
        highlightLayer.masksToBounds = true
        highlightLayer.frame = bounds
        highlightLayer.opacity = 0
        layer.addSublayer(highlightLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 2
        characterLabel.frame = CGRect(x: inset, y: 0, width: bounds.width - inset * 2, height: bounds.height)

        // Des-M3: 1px split line
        splitLine.frame = CGRect(x: 0, y: bounds.height / 2 - 0.5, width: bounds.width, height: 1)
        lightLine.frame = CGRect(x: 0, y: bounds.height / 2 + 0.5, width: bounds.width, height: 1)

        // Resize CALayers — gradient inset 1pt so housing bg peeks through (like web's 1px inset)
        let layerInset = bounds.insetBy(dx: 1, dy: 1)
        bgGradient.frame = layerInset
        scrambleColorLayer.frame = layerInset
        shadowOverlay.frame = layerInset
        highlightLayer.frame = layerInset

        // Des-D5: shadow path for performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 3).cgPath
    }

    func configureFont(size: CGFloat) {
        // Des-M7: SF Pro Bold — more authentic split-flap feel; grid handles alignment
        characterLabel.font = UIFont.systemFont(ofSize: size, weight: .bold)
    }

    // MARK: - Des-D1: Idle Breathing Animation

    /// Start a very subtle idle breathing animation on the shadow overlay.
    func startBreathing() {
        guard breathingAnimation == nil else { return }
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0.28
        anim.toValue = 0.32
        anim.duration = Double.random(in: 20...30) // Vary per tile for organic feel
        anim.autoreverses = true
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        shadowOverlay.add(anim, forKey: "breathing")
        breathingAnimation = anim
    }

    /// Stop the idle breathing animation.
    func stopBreathing() {
        shadowOverlay.removeAnimation(forKey: "breathing")
        breathingAnimation = nil
    }

    // MARK: - Character Display

    func setChar(_ char: Character, color: UIColor = creamColor) {
        currentChar = char
        characterLabel.text = char == " " ? "" : String(char)
        characterLabel.textColor = color
        // Restore gradient bg, hide scramble color
        bgGradient.isHidden = false
        scrambleColorLayer.isHidden = true
        layer.transform = CATransform3DIdentity
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
        stopBreathing()

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.startScramble(target: character, completion: completion)
        }
    }

    /// Returns the active scramble palette based on time slot (Des-D4)
    private func activeScrambleColors() -> [UIColor] {
        switch Self.currentTimeSlot {
        case "morning": return Self.morningScrambleColors
        case "bedtime": return Self.bedtimeScrambleColors
        default: return Self.scrambleColors
        }
    }

    private func startScramble(target: Character, completion: (() -> Void)?) {
        var scrambleCount = 0
        let maxScrambles = Self.scrambleBaseCount + Int.random(in: Self.scrambleRandomRange)
        let palette = activeScrambleColors()

        // Show metallic highlight during scramble
        highlightLayer.opacity = 1

        scrambleTimer?.invalidate()
        scrambleTimer = Timer.scheduledTimer(withTimeInterval: Self.scrambleStepInterval, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }

            // Des-D3: Pick random char that differs from the previous one
            var randChar: Character
            repeat {
                randChar = Self.charset.randomElement() ?? "A"
            } while randChar == self.lastScrambleChar && Self.charset.count > 1
            self.lastScrambleChar = randChar

            let color = palette[scrambleCount % palette.count]
            self.characterLabel.text = randChar == " " ? "" : String(randChar)

            // Des-M5: Use scrambleColorLayer (preserves depth gradients)
            self.scrambleColorLayer.backgroundColor = color.cgColor
            self.scrambleColorLayer.isHidden = false
            self.characterLabel.textColor = .white

            scrambleCount += 1

            if scrambleCount >= maxScrambles {
                timer.invalidate()
                self.scrambleTimer = nil
                self.perform3DFlap(to: target, completion: completion)
            }
        }
    }

    // MARK: - Des-A1: Real 3D Flap Rotation

    /// Performs a real 3D flap rotation: top half rotates forward to reveal the new character.
    private func perform3DFlap(to target: Character, completion: (() -> Void)?) {
        let flapDuration: TimeInterval = 0.15 // 150ms per flap

        // Set up perspective
        var perspective = CATransform3DIdentity
        perspective.m34 = Self.tiltPerspective

        // Create top flap layer (upper half, looks like the scramble state)
        let topFlap = CALayer()
        topFlap.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2)
        topFlap.backgroundColor = scrambleColorLayer.isHidden
            ? UIColor(hex: "#2A2A2A").cgColor
            : scrambleColorLayer.backgroundColor
        topFlap.cornerRadius = 4
        topFlap.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topFlap.masksToBounds = true
        topFlap.anchorPoint = CGPoint(x: 0.5, y: 1.0) // Rotate around bottom edge
        topFlap.position = CGPoint(x: bounds.midX, y: bounds.midY)
        layer.addSublayer(topFlap)

        // Set the final character underneath before flap animates
        let text = target == " " ? "" : String(target)
        characterLabel.text = text
        characterLabel.textColor = Self.creamColor
        scrambleColorLayer.isHidden = true
        bgGradient.isHidden = false

        // Animate top flap rotating forward (0° to -90°)
        let rotation = CABasicAnimation(keyPath: "transform")
        rotation.fromValue = NSValue(caTransform3D: perspective)
        let rotated = CATransform3DRotate(perspective, -.pi / 2, 1, 0, 0)
        rotation.toValue = NSValue(caTransform3D: rotated)
        rotation.duration = flapDuration
        rotation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        rotation.fillMode = .forwards
        rotation.isRemovedOnCompletion = false

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self else { return }
            topFlap.removeFromSuperlayer()

            // Des-A1: Click sound at the moment the flap lands
            // Des-A3: Pan based on column position (-1.0 left to 1.0 right)
            let pan = self.totalColumns > 1
                ? Float(self.columnIndex) / Float(self.totalColumns - 1) * 2.0 - 1.0
                : 0
            FlipSoundEngine.shared.playClick(panPosition: pan)

            // Fade out metallic highlight
            let fadeOut = CABasicAnimation(keyPath: "opacity")
            fadeOut.fromValue = 1
            fadeOut.toValue = 0
            fadeOut.duration = Self.highlightFadeDuration
            self.highlightLayer.add(fadeOut, forKey: "fadeOut")
            self.highlightLayer.opacity = 0

            self.currentChar = target
            self.isAnimating = false
            self.startBreathing()
            completion?()
        }
        topFlap.add(rotation, forKey: "flapRotation")
        CATransaction.commit()
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

