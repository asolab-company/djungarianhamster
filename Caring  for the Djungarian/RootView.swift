import SwiftUI

enum AppRoute: Equatable {
    case onboarding
    case main

}

struct RootView: View {
    @State private var route: AppRoute =
        (UserDefaults.standard.bool(forKey: "didFinishOnboarding")
            ? .main : .onboarding)

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [
                    Color(hex: "FED3E4"),
                    Color(hex: "FED3E4"),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            currentScreen
        }
    }

    @ViewBuilder
    private var currentScreen: some View {
        switch route {
        case .onboarding:
            Onboarding {
                UserDefaults.standard.set(true, forKey: "didFinishOnboarding")
                route = .main
            }

        case .main:
            Main()

        }
    }
}

enum Device {
    static var isSmall: Bool {
        UIScreen.main.bounds.height < 700
    }

    static var isMedium: Bool {
        UIScreen.main.bounds.height >= 700 && UIScreen.main.bounds.height < 850
    }

    static var isLarge: Bool {
        UIScreen.main.bounds.height >= 850
    }
}

#Preview {
    RootView()
}
