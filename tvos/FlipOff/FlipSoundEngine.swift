import AVFoundation
import QuartzCore

/// Audio engine for split-flap display.
///
/// Des-H2: Generates a synthetic "flip wave" transition audio (played once per board transition)
/// plus per-tile mechanical clicks for the 3D flap landing moment.
/// Des-A3: Supports spatial audio panning — tiles on the left pan left, tiles on the right pan right.
class FlipSoundEngine {
    static let shared = FlipSoundEngine()

    // Per-tile click pool (for Des-A1 flap landing sound)
    private var clickPlayers: [AVAudioPlayer] = []
    private let clickPoolSize = 8
    private var currentClickIndex = 0

    // Des-H2: Single transition audio player
    private var transitionPlayer: AVAudioPlayer?

    var isMuted = true  // Start muted — user enables with Play/Pause
    private var lastPlayTime: TimeInterval = 0

    private init() {
        // Generate per-tile click sound (more mechanical than pure sine)
        guard let clickData = generateMechanicalClick() else { return }
        for _ in 0..<clickPoolSize {
            if let player = try? AVAudioPlayer(data: clickData) {
                player.prepareToPlay()
                player.volume = 0.15  // Subtle since transition audio is the main sound
                clickPlayers.append(player)
            }
        }

        // Des-H2: Generate single transition audio
        if let transData = generateTransitionAudio() {
            transitionPlayer = try? AVAudioPlayer(data: transData)
            transitionPlayer?.prepareToPlay()
            transitionPlayer?.volume = 0.5
        }
    }

    /// Play a per-tile click (called when a 3D flap lands).
    /// Des-A3: panPosition ranges from -1.0 (left) to 1.0 (right) for spatial effect.
    func playClick(panPosition: Float = 0) {
        guard !isMuted, !clickPlayers.isEmpty else { return }
        let now = CACurrentMediaTime()
        guard now - lastPlayTime > 0.015 else { return }  // Max ~66 clicks/sec
        lastPlayTime = now
        let player = clickPlayers[currentClickIndex % clickPlayers.count]
        currentClickIndex += 1
        player.pan = panPosition  // Des-A3: spatial positioning
        player.currentTime = 0
        player.play()
    }

    /// Des-H2: Play the full board transition sound once per message change.
    /// Synced with the first tile scramble start.
    func playTransition() {
        guard !isMuted else { return }
        transitionPlayer?.currentTime = 0
        transitionPlayer?.play()
    }

    @discardableResult
    func toggleMute() -> Bool {
        isMuted = !isMuted
        return isMuted
    }

    // MARK: - WAV Generation Helpers

    private func writeWAVHeader(to data: inout Data, numSamples: Int, channels: UInt16 = 1) {
        let bytesPerSample: Int = 2
        let dataSize = numSamples * Int(channels) * bytesPerSample
        let fileSize = 44 + dataSize

        data.append(contentsOf: [0x52, 0x49, 0x46, 0x46]) // "RIFF"
        data.append(contentsOf: withUnsafeBytes(of: UInt32(fileSize - 8).littleEndian) { Array($0) })
        data.append(contentsOf: [0x57, 0x41, 0x56, 0x45]) // "WAVE"
        data.append(contentsOf: [0x66, 0x6D, 0x74, 0x20]) // "fmt "
        data.append(contentsOf: withUnsafeBytes(of: UInt32(16).littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: UInt16(1).littleEndian) { Array($0) })  // PCM
        data.append(contentsOf: withUnsafeBytes(of: channels.littleEndian) { Array($0) })
        let sampleRate: UInt32 = 44100
        data.append(contentsOf: withUnsafeBytes(of: sampleRate.littleEndian) { Array($0) })
        let byteRate = sampleRate * UInt32(channels) * UInt32(bytesPerSample)
        data.append(contentsOf: withUnsafeBytes(of: byteRate.littleEndian) { Array($0) })
        let blockAlign = UInt16(channels) * UInt16(bytesPerSample)
        data.append(contentsOf: withUnsafeBytes(of: blockAlign.littleEndian) { Array($0) })
        data.append(contentsOf: withUnsafeBytes(of: UInt16(16).littleEndian) { Array($0) })
        data.append(contentsOf: [0x64, 0x61, 0x74, 0x61]) // "data"
        data.append(contentsOf: withUnsafeBytes(of: UInt32(dataSize).littleEndian) { Array($0) })
    }

    // MARK: - Per-tile Mechanical Click (more mechanical than pure sine)

    private func generateMechanicalClick() -> Data? {
        let sampleRate: Double = 44100
        let duration: Double = 0.008  // 8ms — shorter, snappier
        let numSamples = Int(sampleRate * duration)

        var audioData = Data()
        writeWAVHeader(to: &audioData, numSamples: numSamples)

        for i in 0..<numSamples {
            let t = Double(i) / sampleRate
            let envelope = exp(-t * 600)  // Very fast decay
            // Lower frequencies + noise burst for mechanical thunk
            let sample = envelope * (
                0.4 * sin(2 * .pi * 400 * t) +    // Low thunk
                0.2 * sin(2 * .pi * 1200 * t) +   // Mid resonance
                0.4 * (Double.random(in: -1...1))  // Noise burst — mechanical rattle
            )
            let int16 = Int16(clamping: Int(sample * 32767))
            audioData.append(contentsOf: withUnsafeBytes(of: int16.littleEndian) { Array($0) })
        }
        return audioData
    }

    // MARK: - Des-H2: Transition Audio (3.5s combined "flip wave")

    /// Generates a synthetic flip-wave: many overlapping mechanical clicks
    /// staggered across ~3.5 seconds, simulating a real split-flap board transition.
    /// Des-A3: Stereo — clicks sweep from left to right matching the visual wave.
    private func generateTransitionAudio() -> Data? {
        let sampleRate: Double = 44100
        let duration: Double = 3.5
        let numSamples = Int(sampleRate * duration)

        // Generate in stereo for spatial sweep (Des-A3)
        var leftChannel = [Double](repeating: 0, count: numSamples)
        var rightChannel = [Double](repeating: 0, count: numSamples)

        // Simulate ~110 tiles (22×5) flipping with stagger
        let totalTiles = 110
        let staggerPerTile: Double = 0.022 // matches visual stagger

        for tileIndex in 0..<totalTiles {
            let startTime = Double(tileIndex) * staggerPerTile
            let startSample = Int(startTime * sampleRate)

            // Each tile produces 2-3 rapid clicks during its scramble
            let clickCount = Int.random(in: 2...3)
            for clickIdx in 0..<clickCount {
                let clickOffset = Int(Double(clickIdx) * 0.07 * sampleRate) // 70ms apart
                let clickStart = startSample + clickOffset

                // Single click duration: ~6ms
                let clickSamples = Int(0.006 * sampleRate)

                // Des-A3: Pan position based on column (tile % 22)
                let col = tileIndex % 22
                let pan = Double(col) / 21.0 // 0.0 (left) to 1.0 (right)
                let leftGain = 1.0 - pan * 0.6  // Subtle panning, not extreme
                let rightGain = 0.4 + pan * 0.6

                for j in 0..<clickSamples {
                    let idx = clickStart + j
                    guard idx < numSamples else { break }
                    let t = Double(j) / sampleRate
                    let env = exp(-t * 700)
                    let click = env * (
                        0.3 * sin(2 * .pi * (350 + Double.random(in: -50...50)) * t) +
                        0.3 * sin(2 * .pi * (900 + Double.random(in: -100...100)) * t) +
                        0.4 * (Double.random(in: -1...1))
                    ) * 0.15  // Scale down since many overlap
                    leftChannel[idx] += click * leftGain
                    rightChannel[idx] += click * rightGain
                }
            }
        }

        // Build stereo WAV
        var audioData = Data()
        writeWAVHeader(to: &audioData, numSamples: numSamples, channels: 2)

        for i in 0..<numSamples {
            let l = Int16(clamping: Int(max(-1, min(1, leftChannel[i])) * 32767))
            let r = Int16(clamping: Int(max(-1, min(1, rightChannel[i])) * 32767))
            audioData.append(contentsOf: withUnsafeBytes(of: l.littleEndian) { Array($0) })
            audioData.append(contentsOf: withUnsafeBytes(of: r.littleEndian) { Array($0) })
        }

        return audioData
    }
}

