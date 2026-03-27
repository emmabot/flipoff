import UIKit

/// A 22×5 grid of split-flap tiles that displays messages with staggered flip animations.
class SplitFlapBoardView: UIView {

    // MARK: - Constants

    static let gridCols = 22
    static let gridRows = 5
    static let staggerDelay: TimeInterval = 0.03  // 30ms per column, matching web wave effect

    // MARK: - Properties

    private var tiles: [[SplitFlapTileView]] = []
    private var currentGrid: [[Character]] = []
    private(set) var isTransitioning = false
    private var pendingMessage: [String]?
    private var pendingAnimations = 0

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

    private func setupBoard() {
        backgroundColor = .black

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

        let marginH: CGFloat = 20
        let marginV: CGFloat = 20
        let gapH: CGFloat = 3
        let gapV: CGFloat = 3

        let availableW = bounds.width - 2 * marginH - CGFloat(Self.gridCols - 1) * gapH
        let availableH = bounds.height - 2 * marginV - CGFloat(Self.gridRows - 1) * gapV

        let tileW = availableW / CGFloat(Self.gridCols)
        let tileH = availableH / CGFloat(Self.gridRows)
        let fontSize = tileH * 0.7

        for r in 0..<Self.gridRows {
            for c in 0..<Self.gridCols {
                let tile = tiles[r][c]
                let x = marginH + CGFloat(c) * (tileW + gapH)
                let y = marginV + CGFloat(r) * (tileH + gapV)
                tile.frame = CGRect(x: x, y: y, width: tileW, height: tileH)
                tile.configureFont(size: fontSize)
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

        for tile in changingTiles {
            let delay = Double(tile.col) * Self.staggerDelay
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

