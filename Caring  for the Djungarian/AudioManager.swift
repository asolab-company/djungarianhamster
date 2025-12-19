import AVFoundation
import Foundation

final class AudioManager {

    static let shared = AudioManager()

    private var musicPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?

    private let soundEnabledKey = "soundEnabled"

    var backgroundMusic: String = "bg_happy"

    private(set) var isSoundEnabled: Bool

    private init() {
        let session = AVAudioSession.sharedInstance()

        try? session.setCategory(
            .playback,
            mode: .default,
            options: [.mixWithOthers]
        )
        try? session.setActive(true)

        if UserDefaults.standard.object(forKey: soundEnabledKey) == nil {
            isSoundEnabled = true
            UserDefaults.standard.set(true, forKey: soundEnabledKey)
        } else {
            isSoundEnabled = UserDefaults.standard.bool(forKey: soundEnabledKey)
        }
    }

    func setSoundEnabled(_ enabled: Bool) {
        isSoundEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: soundEnabledKey)

        if enabled {
            playMusic()
        } else {
            stopMusic()
        }
    }

    func playMusic() {
        guard isSoundEnabled else { return }

        print("🎵 playMusic() called with:", backgroundMusic)
        guard
            let url = Bundle.main.url(
                forResource: backgroundMusic,
                withExtension: "mp3"
            )
        else {
            print("❌ bg music not found in bundle")
            return
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.volume = 1.0
            musicPlayer?.play()
            print("✅ Music started")
        } catch {
            print("❌ Music error:", error)
        }
    }

    func stopMusic() {
        musicPlayer?.stop()
    }

    func pauseMusic() {
        musicPlayer?.pause()
    }

    func resumeMusic() {
        guard isSoundEnabled else { return }
        musicPlayer?.play()
    }

    private func playSFX(_ name: String) {
        guard isSoundEnabled else { return }

        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3")
        else {
            print("❌ sfx \(name) not found")
            return
        }

        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.volume = 1.0
            sfxPlayer?.play()
        } catch {
            print("❌ SFX error:", error)
        }
    }
}
