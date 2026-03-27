import Foundation

// MARK: - JSON Models

struct MessageData: Decodable {
    let config: MessageConfig
    let messages: MessageGroups
}

struct MessageConfig: Decodable {
    let gridCols: Int
    let gridRows: Int
    let riddleDelay: Double      // in ms
    let messageInterval: Double  // in ms
    let scrambleColors: [String]
    let weather: WeatherConfig
}

struct WeatherConfig: Decodable {
    let url: String
    let codes: [String: String]
}

struct MessageGroups: Decodable {
    let `default`: [MessageJSON]
    let morning: [MessageJSON]
    let bedtime: [MessageJSON]
}

struct MessageJSON: Decodable {
    let type: String
    let lines: [String]?
    let question: [String]?
    let answer: [String]?
}

// MARK: - Message enum

enum Message {
    case plain([String])
    case joke([String])
    case riddle(question: [String], answer: [String])
    case fact([String])

    var displayLines: [String] {
        switch self {
        case .plain(let l), .joke(let l), .fact(let l): return l
        case .riddle(let q, _): return q
        }
    }
}

// MARK: - MessageService

class MessageService {
    static let shared = MessageService()

    private let jsonURL = "https://emmabot.github.io/flipoff/messages.json"

    var config: MessageConfig?
    var defaultMessages: [Message] = []
    var morningMessages: [Message] = []
    var bedtimeMessages: [Message] = []

    func fetch(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: jsonURL) else {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else {
                print("[FlipOff] JSON fetch failed: \(error?.localizedDescription ?? "unknown")")
                completion(false)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(MessageData.self, from: data)
                self.config = decoded.config
                self.defaultMessages = decoded.messages.default.map(self.convert).shuffled()
                self.morningMessages = decoded.messages.morning.map(self.convert)
                self.bedtimeMessages = decoded.messages.bedtime.map(self.convert)
                print("[FlipOff] Loaded \(self.defaultMessages.count) default, \(self.morningMessages.count) morning, \(self.bedtimeMessages.count) bedtime messages")
                completion(true)
            } catch {
                print("[FlipOff] JSON parse error: \(error)")
                completion(false)
            }
        }.resume()
    }

    private func convert(_ json: MessageJSON) -> Message {
        switch json.type {
        case "riddle":
            if let q = json.question, let a = json.answer {
                return .riddle(question: q, answer: a)
            }
            return .plain(json.lines ?? ["", "", "", "", ""])
        case "joke":
            return .joke(json.lines ?? ["", "", "", "", ""])
        case "fact":
            return .fact(json.lines ?? ["", "", "", "", ""])
        default:
            // quote, reminder, bedtime_quote, etc. — all display as plain
            return .plain(json.lines ?? ["", "", "", "", ""])
        }
    }
}

