import AVFoundation

/// Generates a short mechanical click WAV in memory and plays it through a pool
/// of `AVAudioPlayer` instances so overlapping tile flips each get their own click.
class FlipSoundEngine {
    static let shared = FlipSoundEngine()

    private var players: [AVAudioPlayer] = []
    private let playerCount = 4  // Pool for overlapping clicks
    private var currentPlayer = 0
    var isMuted = true  // Start muted — user enables with Play/Pause

    private init() {
        guard let soundData = generateClickSound() else { return }
        for _ in 0..<playerCount {
            if let player = try? AVAudioPlayer(data: soundData) {
                player.prepareToPlay()
                player.volume = 0.3
                players.append(player)
            }
        }
    }

    func playClick() {
        guard !isMuted, !players.isEmpty else { return }
        let player = players[currentPlayer % players.count]
        currentPlayer += 1
        player.currentTime = 0
        player.play()
    }

    @discardableResult
    func toggleMute() -> Bool {
        isMuted = !isMuted
        return isMuted
    }

    // MARK: - WAV Generation

    private func generateClickSound() -> Data? {
        let sampleRate: Double = 44100
        let duration: Double = 0.012  // 12ms click
        let numSamples = Int(sampleRate * duration)

        var audioData = Data()

        // WAV header
        let dataSize = numSamples * 2  // 16-bit samples
        let fileSize = 44 + dataSize

        // RIFF header
        audioData.append(contentsOf: [0x52, 0x49, 0x46, 0x46]) // "RIFF"
        audioData.append(contentsOf: withUnsafeBytes(of: UInt32(fileSize - 8).littleEndian) { Array($0) })
        audioData.append(contentsOf: [0x57, 0x41, 0x56, 0x45]) // "WAVE"

        // fmt chunk
        audioData.append(contentsOf: [0x66, 0x6D, 0x74, 0x20]) // "fmt "
        audioData.append(contentsOf: withUnsafeBytes(of: UInt32(16).littleEndian) { Array($0) })
        audioData.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) })  // PCM
        audioData.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) })  // Mono
        audioData.append(contentsOf: withUnsafeBytes(of: UInt32(44100).littleEndian) { Array($0) })  // Sample rate
        audioData.append(contentsOf: withUnsafeBytes(of: UInt32(88200).littleEndian) { Array($0) })  // Byte rate
        audioData.append(contentsOf: withUnsafeBytes(of: UInt16(2).littleEndian) { Array($0) })  // Block align
        audioData.append(contentsOf: withUnsafeBytes(of: UInt16(16).littleEndian) { Array($0) })  // Bits per sample

        // data chunk
        audioData.append(contentsOf: [0x64, 0x61, 0x74, 0x61]) // "data"
        audioData.append(contentsOf: withUnsafeBytes(of: UInt32(dataSize).littleEndian) { Array($0) })

        // Generate a short mechanical click: sharp attack, fast decay, slight metallic ring
        for i in 0..<numSamples {
            let t = Double(i) / sampleRate
            let envelope = exp(-t * 400)  // Fast decay
            // Mix of frequencies for mechanical sound
            let sample = envelope * (
                0.6 * sin(2 * .pi * 800 * t) +    // Base click
                0.3 * sin(2 * .pi * 2400 * t) +   // Metallic overtone
                0.1 * (Double.random(in: -1...1))  // Noise component
            )
            let int16Sample = Int16(max(-32767, min(32767, sample * 32767)))
            audioData.append(contentsOf: withUnsafeBytes(of: int16Sample.littleEndian) { Array($0) })
        }

        return audioData
    }
}

