import Foundation

// MARK: - JSON Models

struct MessageData: Decodable {
    let config: MessageConfig
    let modes: [String: MessageMode]
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

struct MessageMode: Decodable {
    let `default`: [MessageJSON]
    let morning: [MessageJSON]?
    let bedtime: [MessageJSON]?
    let rps: [MessageJSON]?
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

    private let jsonURL = "https://emmabot.github.io/lilsauce/messages.json"

    var config: MessageConfig?
    var defaultMessages: [Message] = []
    var morningMessages: [Message] = []
    var bedtimeMessages: [Message] = []
    var rpsMessages: [Message] = []

    func fetch(mode: String = "kids", completion: @escaping (Bool) -> Void) {
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
                guard let modeData = decoded.modes[mode] else {
                    print("[FlipOff] Mode '\(mode)' not found in JSON")
                    completion(false)
                    return
                }
                self.defaultMessages = modeData.default.map(self.convert).shuffled()
                self.morningMessages = (modeData.morning ?? []).map(self.convert)
                self.bedtimeMessages = (modeData.bedtime ?? []).map(self.convert)
                self.rpsMessages = (modeData.rps ?? []).map(self.convert)
                print("[FlipOff] Loaded mode '\(mode)': \(self.defaultMessages.count) default, \(self.morningMessages.count) morning, \(self.bedtimeMessages.count) bedtime, \(self.rpsMessages.count) rps messages")
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

