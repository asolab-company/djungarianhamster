import SwiftUI

struct Main: View {
    @State private var isSoundOn: Bool = AudioManager.shared.isSoundEnabled

    @State private var showProfile = false
    @State private var showCalendar = false
    @State private var showDailyCare = false
    @State private var showWeeklyCare = false
    @State private var showMonthlyCare = false
    @State private var showInfo = false

    var body: some View {

        ZStack(alignment: .top) {

            Image("onb_bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: Device.isSmall ? 90 : 130)
                .clipShape(

                    RoundedCorner(
                        radius: 42,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )
                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        showProfile = true
                    } label: {
                        Image("ic_profile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }

                    Spacer()

                    Button {

                        isSoundOn.toggle()
                        AudioManager.shared.setSoundEnabled(isSoundOn)
                    } label: {
                        Image(isSoundOn ? "ic_on" : "ic_off")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }

                    Spacer()

                    Button {
                        showCalendar = true
                    } label: {
                        Image("ic_calendar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer()
                VStack {

                    Button {
                        showDailyCare = true
                    } label: {
                        Image("d_care")
                            .resizable()
                            .scaledToFit()

                    }
                    Button {
                        showWeeklyCare = true
                    } label: {
                        Image("w_care")
                            .resizable()
                            .scaledToFit()

                    }
                    Button {
                        showMonthlyCare = true
                    } label: {
                        Image("m_care")
                            .resizable()
                            .scaledToFit()

                    }
                }
                .padding(.horizontal, Device.isSmall ? 50 : 30)
                Spacer()

                HStack {
                    Button {
                        showInfo = true
                    } label: {
                        Image("ic_info")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                    }
                    Spacer()
                }.padding(.horizontal, 20)
                    .padding(.bottom)

            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $showProfile) {
            Profile { showProfile = false }
        }
        .fullScreenCover(isPresented: $showCalendar) {
            CalendarView { showCalendar = false }
        }
        .fullScreenCover(isPresented: $showDailyCare) {
            DailyCare { showDailyCare = false }
        }
        .fullScreenCover(isPresented: $showWeeklyCare) {
            WeeklyList { showWeeklyCare = false }
        }
        .fullScreenCover(isPresented: $showMonthlyCare) {
            MonthlyList { showMonthlyCare = false }
        }
        .fullScreenCover(isPresented: $showInfo) {
            Info { showInfo = false }
        }
        .background(
            Color(.white).ignoresSafeArea()
        )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    Main()
}
