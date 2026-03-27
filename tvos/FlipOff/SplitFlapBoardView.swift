import UIKit

/// A 22×5 grid of split-flap tiles that displays messages with staggered flip animations.
class SplitFlapBoardView: UIView {

    // MARK: - Constants

    static let gridCols = 22
    static let gridRows = 5
    static let staggerDelay: TimeInterval = 0.022  // 22ms per tile position, diagonal sweep
    static let accentColors: [UIColor] = [
        UIColor(hex: "#E8A840"), UIColor(hex: "#D4735E"), UIColor(hex: "#6BA3BE"),
        UIColor(hex: "#7BA068"), UIColor(hex: "#9B8EC4")
    ]

    // MARK: - Properties

    private var tiles: [[SplitFlapTileView]] = []
    private var currentGrid: [[Character]] = []
    private(set) var isTransitioning = false
    private var pendingMessage: [String]?
    private var pendingAnimations = 0
    private var accentIndex = 0
    private var leftTopIndicator: UIView?
    private var leftBottomIndicator: UIView?
    private var rightTopIndicator: UIView?
    private var rightBottomIndicator: UIView?

    // Des-A2: Ambient light reflection
    private let ambientGradient = CAGradientLayer()
    private let cornerVignette = CAGradientLayer()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBoard()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBoard()
    }

    private var hasDisplayedFirstMessage = false
    private var loadingScrambleTimer: Timer?

    private func setupBoard() {
        backgroundColor = UIColor(red: 0x08/255.0, green: 0x08/255.0, blue: 0x08/255.0, alpha: 1)

        // Accent indicator bars — LED-style dots in each top corner
        func makeIndicator() -> UIView {
            let v = UIView()
            v.layer.cornerRadius = 5  // Half of 10pt size = perfect circle
            v.clipsToBounds = false
            v.layer.shadowRadius = 6
            v.layer.shadowOpacity = 0.8
            v.layer.shadowOffset = .zero
            return v
        }
        leftTopIndicator = makeIndicator()
        leftBottomIndicator = makeIndicator()
        rightTopIndicator = makeIndicator()
        rightBottomIndicator = makeIndicator()
        for v in [leftTopIndicator!, leftBottomIndicator!, rightTopIndicator!, rightBottomIndicator!] {
            addSubview(v)
        }
        updateAccentColors()

        for r in 0..<Self.gridRows {
            var row: [SplitFlapTileView] = []
            var charRow: [Character] = []
            for c in 0..<Self.gridCols {
                let tile = SplitFlapTileView()
                tile.translatesAutoresizingMaskIntoConstraints = false
                // Tag first tile for debug logging
                if r == 0 && c == 0 { tile.tag = 1 }
                tile.setChar(" ")
                // Des-A3: Set column info for spatial audio panning
                tile.columnIndex = c
                tile.totalColumns = Self.gridCols
                addSubview(tile)
                row.append(tile)
                charRow.append(" ")
            }
            tiles.append(row)
            currentGrid.append(charRow)
        }

        // Des-A2: Ambient light reflection — subtle diagonal gradient that shifts slowly
        ambientGradient.colors = [
            UIColor(white: 1, alpha: 0.02).cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor
        ]
        ambientGradient.startPoint = CGPoint(x: 0, y: 0)
        ambientGradient.endPoint = CGPoint(x: 1, y: 1)
        ambientGradient.frame = bounds
        layer.addSublayer(ambientGradient)
        startAmbientAnimation()

        // Corner vignette — glass edge darkening (matches web at ~0.25, softer than web's 0.4 for TV viewing)
        cornerVignette.type = .radial
        cornerVignette.colors = [
            UIColor.clear.cgColor,
            UIColor(white: 0, alpha: 0.25).cgColor
        ]
        cornerVignette.locations = [0.6, 1.0]
        cornerVignette.startPoint = CGPoint(x: 0.5, y: 0.5)
        cornerVignette.endPoint = CGPoint(x: 1, y: 1)
        cornerVignette.frame = bounds
        layer.addSublayer(cornerVignette)
    }

    /// Des-A2: Animate the ambient light gradient position slowly over 60 seconds
    private func startAmbientAnimation() {
        let anim = CABasicAnimation(keyPath: "startPoint")
        anim.fromValue = CGPoint(x: 0, y: 0)
        anim.toValue = CGPoint(x: 1, y: 0.3)
        anim.duration = 60
        anim.autoreverses = true
        anim.repeatCount = .infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        ambientGradient.add(anim, forKey: "ambientShift")

        let anim2 = CABasicAnimation(keyPath: "endPoint")
        anim2.fromValue = CGPoint(x: 1, y: 1)
        anim2.toValue = CGPoint(x: 0.3, y: 1)
        anim2.duration = 60
        anim2.autoreverses = true
        anim2.repeatCount = .infinity
        anim2.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        ambientGradient.add(anim2, forKey: "ambientShift2")
    }

    /// Start idle breathing animation on all tiles
    func startTileBreathing() {
        for row in tiles {
            for tile in row {
                tile.startBreathing()
            }
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        // Des-A2: Resize ambient layers
        ambientGradient.frame = bounds
        cornerVignette.frame = bounds

        let marginH: CGFloat = 60   // P1: increased from 20
        let marginV: CGFloat = 40   // P1: increased from 20
        let gapH: CGFloat = 5       // P1: increased from 3
        let gapV: CGFloat = 5       // P1: increased from 3

        let availableW = bounds.width - marginH * 2 - CGFloat(Self.gridCols - 1) * gapH
        let availableH = bounds.height - marginV * 2 - CGFloat(Self.gridRows - 1) * gapV

        let tileW = availableW / CGFloat(Self.gridCols)
        let rawTileH = availableH / CGFloat(Self.gridRows)
        let tileH = min(rawTileH, tileW * 1.5)  // P0: Cap at 1:1.5 aspect ratio

        // Center the grid vertically (tiles may not fill full height)
        let totalGridH = CGFloat(Self.gridRows) * tileH + CGFloat(Self.gridRows - 1) * gapV
        let offsetY = (bounds.height - totalGridH) / 2
        let offsetX = marginH

        let fontSize = tileH * 0.50  // Des-H3: reduced from 0.55

        // Position accent indicator dots (10×10pt LED circles, 24pt from edges)
        let indicatorSize: CGFloat = 10
        let indicatorInset: CGFloat = 24
        let indicatorGap: CGFloat = 8
        leftTopIndicator?.frame = CGRect(x: indicatorInset, y: indicatorInset, width: indicatorSize, height: indicatorSize)
        leftBottomIndicator?.frame = CGRect(x: indicatorInset, y: indicatorInset + indicatorSize + indicatorGap, width: indicatorSize, height: indicatorSize)
        rightTopIndicator?.frame = CGRect(x: bounds.width - indicatorInset - indicatorSize, y: indicatorInset, width: indicatorSize, height: indicatorSize)
        rightBottomIndicator?.frame = CGRect(x: bounds.width - indicatorInset - indicatorSize, y: indicatorInset + indicatorSize + indicatorGap, width: indicatorSize, height: indicatorSize)

        for r in 0..<Self.gridRows {
            for c in 0..<Self.gridCols {
                let x = offsetX + CGFloat(c) * (tileW + gapH)
                let y = offsetY + CGFloat(r) * (tileH + gapV)
                tiles[r][c].frame = CGRect(x: x, y: y, width: tileW, height: tileH)
                tiles[r][c].configureFont(size: fontSize)
            }
        }
    }

    // MARK: - Display Message

    /// Display a message as 5 rows of strings. Each string is centered in the 22-column grid.
    func display(message: [String]) {
        print("[FlipOff] Displaying: \(message)")
        if isTransitioning {
            pendingMessage = message
            return
        }

        let newGrid = formatToGrid(message)

        // First message: set characters directly (no animation) to verify rendering
        if !hasDisplayedFirstMessage {
            hasDisplayedFirstMessage = true
            displayWithoutAnimation(grid: newGrid)
            return
        }

        // Collect tiles that actually need to change
        var changingTiles: [(row: Int, col: Int, char: Character)] = []

        for r in 0..<Self.gridRows {
            for c in 0..<Self.gridCols {
                let newChar = newGrid[r][c]
                let oldChar = currentGrid[r][c]
                if newChar != oldChar {
                    changingTiles.append((r, c, newChar))
                }
            }
        }

        currentGrid = newGrid

        if changingTiles.isEmpty {
            // No changes needed — check for pending
            if let pending = pendingMessage {
                pendingMessage = nil
                display(message: pending)
            }
            return
        }

        isTransitioning = true
        pendingAnimations = changingTiles.count

        // Cycle accent indicator colors on each message change
        accentIndex += 1
        updateAccentColors()

        // Des-H2: Play single transition audio clip synced with first tile scramble
        FlipSoundEngine.shared.playTransition()

        for tile in changingTiles {
            let delay = Double(tile.row * Self.gridCols + tile.col) * Self.staggerDelay
            tiles[tile.row][tile.col].flip(to: tile.char, delay: delay) { [weak self] in
                self?.tileAnimationCompleted()
            }
        }
    }

    private func tileAnimationCompleted() {
        pendingAnimations -= 1
        if pendingAnimations <= 0 {
            pendingAnimations = 0
            isTransitioning = false
            if let pending = pendingMessage {
                pendingMessage = nil
                display(message: pending)
            }
        }
    }

    /// Display grid content immediately without flip animation (used for first message).
    private func displayWithoutAnimation(grid: [[Character]]) {
        print("[FlipOff] displayWithoutAnimation — setting chars directly")
        for r in 0..<Self.gridRows {
            for c in 0..<Self.gridCols {
                let char = grid[r][c]
                tiles[r][c].setChar(char)
            }
        }
        currentGrid = grid
        isTransitioning = false
        startTileBreathing() // Des-D1: begin breathing after first display
    }

    // MARK: - Loading Scramble

    /// Start a continuous random character scramble on all tiles (used as loading state).
    func startLoadingScramble() {
        loadingScrambleTimer?.invalidate()
        loadingScrambleTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            for r in 0..<Self.gridRows {
                for c in 0..<Self.gridCols {
                    let randChar = SplitFlapTileView.charset.randomElement() ?? "A"
                    let color = SplitFlapTileView.scrambleColors[(r * Self.gridCols + c + Int.random(in: 0..<6)) % SplitFlapTileView.scrambleColors.count]
                    let tile = self.tiles[r][c]
                    tile.setChar(randChar, color: .white)
                    tile.backgroundColor = color
                }
            }
        }
    }

    /// Stop the loading scramble and transition into the first real message.
    func stopLoadingScramble() {
        loadingScrambleTimer?.invalidate()
        loadingScrambleTimer = nil
        // Reset tiles to blank so the first message display works cleanly
        for r in 0..<Self.gridRows {
            for c in 0..<Self.gridCols {
                tiles[r][c].setChar(" ")
            }
        }
    }

    var isLoadingScrambleActive: Bool {
        return loadingScrambleTimer != nil
    }

    // MARK: - Accent Indicators

    private func updateAccentColors() {
        let color = Self.accentColors[accentIndex % Self.accentColors.count]
        UIView.animate(withDuration: 0.8) {
            for v in [self.leftTopIndicator, self.leftBottomIndicator, self.rightTopIndicator, self.rightBottomIndicator] {
                v?.backgroundColor = color
                v?.layer.shadowColor = color.cgColor
            }
        }
    }

    // MARK: - Grid Formatting

    private func formatToGrid(_ lines: [String]) -> [[Character]] {
        var grid: [[Character]] = []
        for r in 0..<Self.gridRows {
            let line = r < lines.count ? lines[r].uppercased() : ""
            let padTotal = Self.gridCols - line.count
            let padLeft = max(0, padTotal / 2)
            let padRight = max(0, Self.gridCols - padLeft - line.count)
            let padded = String(repeating: " ", count: padLeft) + line + String(repeating: " ", count: padRight)
            // Ensure exactly gridCols characters
            let chars = Array(padded.prefix(Self.gridCols))
            if chars.count < Self.gridCols {
                grid.append(chars + Array(repeating: Character(" "), count: Self.gridCols - chars.count))
            } else {
                grid.append(chars)
            }
        }
        return grid
    }
}

