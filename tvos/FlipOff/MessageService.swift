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

    // MARK: - Configuration

    /// Remote URL for messages JSON (configurable constant)
    static let remoteJSONURL = "https://emmabot.github.io/lilsauce/messages.json"

    /// UserDefaults key for disk-cached JSON
    private static let cachedJSONKey = "cachedMessagesJSON"

    // MARK: - Properties

    private(set) var config: MessageConfig?
    private(set) var defaultMessages: [Message] = []
    private(set) var morningMessages: [Message] = []
    private(set) var bedtimeMessages: [Message] = []
    private(set) var rpsMessages: [Message] = []

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        return URLSession(configuration: config)
    }()

    // MARK: - Fetch

    func fetch(mode: String = "kids", completion: @escaping (Bool) -> Void) {
        defaultMessages = []
        morningMessages = []
        bedtimeMessages = []
        rpsMessages = []

        guard let url = URL(string: Self.remoteJSONURL) else {
            loadFallback(mode: mode, completion: completion)
            return
        }

        session.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else {
                print("[FlipOff] JSON fetch failed: \(error?.localizedDescription ?? "unknown"), trying fallback")
                self?.loadFallback(mode: mode, completion: completion)
                return
            }

            if self.parse(data: data, mode: mode) {
                // Cache successful network response to disk
                UserDefaults.standard.set(data, forKey: Self.cachedJSONKey)
                print("[FlipOff] Cached messages.json to disk")
                completion(true)
            } else {
                self.loadFallback(mode: mode, completion: completion)
            }
        }.resume()
    }

    // MARK: - Fallback & Cache

    /// Try disk cache first, then bundled fallback
    private func loadFallback(mode: String, completion: @escaping (Bool) -> Void) {
        // 1. Try disk-cached version
        if let cachedData = UserDefaults.standard.data(forKey: Self.cachedJSONKey) {
            if parse(data: cachedData, mode: mode) {
                print("[FlipOff] Loaded messages from disk cache")
                completion(true)
                return
            }
        }

        // 2. Try bundled fallback
        if let bundlePath = Bundle.main.path(forResource: "messages", ofType: "json"),
           let bundleData = try? Data(contentsOf: URL(fileURLWithPath: bundlePath)) {
            if parse(data: bundleData, mode: mode) {
                print("[FlipOff] Loaded messages from app bundle fallback")
                completion(true)
                return
            }
        }

        print("[FlipOff] All message sources failed")
        completion(false)
    }

    /// Parse JSON data and populate message arrays. Returns true on success.
    private func parse(data: Data, mode: String) -> Bool {
        do {
            let decoded = try JSONDecoder().decode(MessageData.self, from: data)
            self.config = decoded.config
            guard let modeData = decoded.modes[mode] else {
                print("[FlipOff] Mode '\(mode)' not found in JSON")
                return false
            }
            self.defaultMessages = modeData.default.map(self.convert).shuffled()
            self.morningMessages = (modeData.morning ?? []).map(self.convert)
            self.bedtimeMessages = (modeData.bedtime ?? []).map(self.convert)
            self.rpsMessages = (modeData.rps ?? []).map(self.convert)
            print("[FlipOff] Loaded mode '\(mode)': \(self.defaultMessages.count) default, \(self.morningMessages.count) morning, \(self.bedtimeMessages.count) bedtime, \(self.rpsMessages.count) rps messages")
            return true
        } catch {
            print("[FlipOff] JSON parse error: \(error)")
            return false
        }
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

