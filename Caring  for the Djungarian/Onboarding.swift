import SwiftUI

struct Onboarding: View {
    @State private var page: Int = 0
    var onFinish: () -> Void
    private let images = ["onb_1", "onb_2", "onb_3"]
    private let titles = [
        "Hamster Care\nPlanner",
        "Caring Made\nSimple",
        "Your Hamster’s\nDaily Routine",
    ]
    private let subtitles = [
        "Track daily, weekly, and monthly care tasks for\nyour Djungarian hamster. Stay organized and\nkeep your little friend happy.",
        "From fresh water to vet visits — create a\nconsistent, loving routine for your hamster in\none easy app.",
        "Plan, track, and never miss a care task. Feeding,\ncleaning, playing — all in one place,\nall on time.",
    ]

    var body: some View {

        ZStack {
            Image(images[page])
                .resizable()
                .scaledToFit()
                .padding(.bottom, 100)
                .animation(.easeInOut, value: page)

            VStack {
                Spacer()
                OnboardingCardView(
                    currentPage: page,
                    totalPages: 3,
                    title: titles[page],
                    subtitle: subtitles[page],
                    buttonTitle: page == 2 ? "Start" : "Next",
                    onNext: {
                        if page < 2 {
                            withAnimation(.easeInOut) {
                                page += 1
                            }
                        } else {
                            onFinish()
                        }
                    }
                )
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
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

                Image("onb_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

            }
        )
    }
}

struct OnboardingCardView: View {
    var currentPage: Int
    var totalPages: Int
    var title: String
    var subtitle: String
    var buttonTitle: String
    var onNext: () -> Void

    var body: some View {
        ZStack(alignment: .top) {

            RoundedRectangle(cornerRadius: 52, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 52, style: .continuous)
                        .stroke(Color(hex: "FF4991"), lineWidth: 2)
                )
                .shadow(
                    color: Color.black.opacity(0.06),
                    radius: 12,
                    x: 0,
                    y: -4
                )
                .ignoresSafeArea(edges: .bottom)

            VStack(spacing: 20) {

                HStack(spacing: 8) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Circle()
                            .fill(
                                index == currentPage
                                    ? Color(red: 1.0, green: 0.27, blue: 0.60)
                                    : Color.gray.opacity(0.3)
                            )
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 30)

                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "60434D"))
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "60434D"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Button(action: onNext) {
                    Text(buttonTitle)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(hex: "FED3E4"),
                                    Color(hex: "FF4991"),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 32)
            }
        }
        .frame(height: 280)
    }
}

#Preview {
    Onboarding {}
}
