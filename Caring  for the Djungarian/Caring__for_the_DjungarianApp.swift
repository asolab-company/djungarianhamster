import SwiftUI

@main
struct Caeing__for_the_DjungarianApp: App {

    @Environment(\.scenePhase) private var phase

    var body: some Scene {
        WindowGroup {
            RootView().onAppear {
                AudioManager.shared.playMusic()
            }
        }
        .onChange(of: phase) { newPhase in
            let audio = AudioManager.shared

            if newPhase == .background || newPhase == .inactive {
                audio.pauseMusic()
            } else if newPhase == .active {
                audio.resumeMusic()
            }
        }
    }
}

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }
}
