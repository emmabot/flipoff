import UIKit

/// Shared mode definition used by both ModePickerViewController and ViewController.
/// Single source of truth for mode metadata (Eng-M7).
struct ModeDefinition {
    let id: String
    let title: String
    let description: String
    let color: UIColor

    static let all: [ModeDefinition] = [
        ModeDefinition(id: "kids", title: "KIDS",
                       description: "Jokes, riddles, math puzzles\ngames, and fun facts",
                       color: UIColor(hex: "#E8A840")),
        ModeDefinition(id: "innovator", title: "INNOVATOR",
                       description: "Tech history, science\nquotes, and startup wisdom",
                       color: UIColor(hex: "#6BA3BE")),
        ModeDefinition(id: "history", title: "HISTORY",
                       description: "World events, famous quotes\nand ancient wonders",
                       color: UIColor(hex: "#9B8EC4"))
    ]
}

