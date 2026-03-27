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
        backgroundColor = UIColor(red: 0x11/255.0, green: 0x11/255.0, blue: 0x11/255.0, alpha: 1)

        // Accent indicator bars — two small squares in each top corner
        func makeIndicator() -> UIView {
            let v = UIView()
            v.layer.cornerRadius = 3
            v.clipsToBounds = true
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
                addSubview(tile)
                row.append(tile)
                charRow.append(" ")
            }
            tiles.append(row)
            currentGrid.append(charRow)
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

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

        // Position accent indicator squares (14×14pt, 18pt from edges)
        let indicatorSize: CGFloat = 14
        let indicatorInset: CGFloat = 18
        let indicatorGap: CGFloat = 4
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
        for v in [leftTopIndicator, leftBottomIndicator, rightTopIndicator, rightBottomIndicator] {
            v?.backgroundColor = color
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

