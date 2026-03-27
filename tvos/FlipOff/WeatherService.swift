import Foundation

class WeatherService {
    static let shared = WeatherService()

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        return URLSession(configuration: config)
    }()

    func fetchWeather(config: WeatherConfig, completion: @escaping (Message?) -> Void) {
        guard let url = URL(string: config.url) else {
            completion(nil)
            return
        }

        session.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let current = json["current"] as? [String: Any],
                  let temp = current["temperature_2m"] as? Double,
                  let code = current["weather_code"] as? Int else {
                print("[FlipOff] Weather fetch failed: \(error?.localizedDescription ?? "parse error")")
                completion(nil)
                return
            }

            let label = config.codes[String(code)] ?? "CLEAR"
            let tempStr = "\(Int(temp.rounded()))°F  \(label)"
            let message = Message.plain(["", "GOOD MORNING", tempStr, "", ""])
            print("[FlipOff] Weather: \(tempStr)")
            completion(message)
        }.resume()
    }

    func moonPhaseName() -> String {
        guard let knownNewMoon = DateComponents(calendar: .current, year: 2000, month: 1, day: 6).date else {
            return "FULL MOON"
        }
        let daysSince = Date().timeIntervalSince(knownNewMoon) / 86400.0
        let lunarCycle = 29.53
        let phase = daysSince.truncatingRemainder(dividingBy: lunarCycle)
        let p = phase < 0 ? phase + lunarCycle : phase

        switch p {
        case 0..<1.85: return "NEW MOON"
        case 1.85..<5.53: return "WAXING CRESCENT"
        case 5.53..<9.22: return "FIRST QUARTER"
        case 9.22..<12.91: return "WAXING GIBBOUS"
        case 12.91..<16.61: return "FULL MOON"
        case 16.61..<20.30: return "WANING GIBBOUS"
        case 20.30..<23.99: return "LAST QUARTER"
        case 23.99..<27.68: return "WANING CRESCENT"
        default: return "NEW MOON"
        }
    }

    func moonMessage() -> Message {
        return .plain(["", "TONIGHTS MOON", moonPhaseName(), "", ""])
    }
}

