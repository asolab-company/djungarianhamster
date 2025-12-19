import SwiftUI

struct Profile: View {

    @AppStorage("profile_breed") private var breed: String = ""
    @AppStorage("profile_name") private var name: String = ""
    @AppStorage("profile_age") private var age: String = ""
    @AppStorage("profile_gender") private var gender: String = ""

    @Environment(\.dismiss) private var dismiss
    var onClose: () -> Void
    var body: some View {

        ZStack(alignment: .top) {

            Image("onb_bg")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 350)
                .clipShape(

                    RoundedCorner(
                        radius: 42,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )

                .clipped()
                .ignoresSafeArea()

            VStack(spacing: 10) {
                HStack {
                    Button {
                        onClose()
                    } label: {
                        Image("ic_back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }

                    Spacer()

                }
                .padding(.horizontal, 20)

                Spacer()

                ZStack {

                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 32,
                                style: .continuous
                            )
                            .stroke(Color(hex: "FED3E4"), lineWidth: 2)

                        )

                    VStack(spacing: 16) {

                        Text("Profile")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color(hex: "60434D"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 10) {
                                ProfilePillField(
                                    title: "Breed",
                                    placeholder: "Djungarian hamster",
                                    text: $breed
                                )

                                ProfilePillField(
                                    title: "Name",
                                    placeholder: "Jack",
                                    text: $name
                                )

                                ProfilePillField(
                                    title: "Age",
                                    placeholder: "6 month",
                                    text: $age
                                )

                                ProfilePillField(
                                    title: "Gender",
                                    placeholder: "Male",
                                    text: $gender
                                )

                                Text("Hamster States")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(hex: "60434D"))
                                    .padding(.top, 8)

                                HamsterStatesView()
                                    .padding(.bottom)
                            }

                        }
                    }

                    .padding(.vertical)
                    .padding(.horizontal, 26)
                }.padding(.horizontal)

                Spacer()

            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        .background(
            Color(.white).ignoresSafeArea()
        )
    }
}

private struct ProfilePillField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(hex: "60434D"))

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.gray.opacity(0.7))
                        .italic()
                }

                TextField("", text: $text)
                    .foregroundColor(Color(hex: "60434D"))
            }
            .padding(.horizontal, 24)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 35, style: .continuous)
                    .stroke(Color(hex: "FED3E4"), lineWidth: 2)
            )
        }.padding(.horizontal, 1)
    }
}

private struct HamsterStatesView: View {

    private let moodKey = "DailyList.mood"

    private enum HamsterMood: Int {
        case nice = 0
        case good = 1
        case bad = 2
    }

    private var points: [CGFloat] {
        let defaults = UserDefaults.standard

        guard defaults.object(forKey: moodKey) != nil else {
            return Array(repeating: 0.0, count: 30)
        }

        let raw = defaults.integer(forKey: moodKey)
        let mood = HamsterMood(rawValue: raw) ?? .good

        let baseValue: CGFloat
        switch mood {
        case .nice:
            baseValue = 0.9

        case .good:
            baseValue = 0.5

        case .bad:
            baseValue = 0.2

        }

        return Array(repeating: baseValue, count: 30)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {

            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(hex: "FFEAF2"))
                    .frame(width: 12, height: 120)

                    .padding(.vertical, 4)

                VStack(spacing: 28) {
                    Text("😊").font(.system(size: 26))
                    Text("🙂").font(.system(size: 26))
                    Text("😠").font(.system(size: 26))
                }
                .padding(.bottom)
            }

            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height

                let leftPadding: CGFloat = 16
                let rightPadding: CGFloat = 8
                let topPadding: CGFloat = 8
                let bottomPadding: CGFloat = 28

                let chartWidth = width - leftPadding - rightPadding
                let count = max(points.count, 2)
                let stepX = chartWidth / CGFloat(count - 1)

                ZStack(alignment: .bottomLeading) {

                    Path { path in
                        let leftX = leftPadding
                        let bottomY = height - bottomPadding
                        let topY = topPadding
                        let rightX = width - rightPadding

                        path.move(to: CGPoint(x: leftX, y: topY))
                        path.addLine(to: CGPoint(x: leftX, y: bottomY))

                        path.move(to: CGPoint(x: leftX, y: bottomY))
                        path.addLine(to: CGPoint(x: rightX, y: bottomY))
                    }
                    .stroke(Color(hex: "FED3E4"), lineWidth: 3)

                    Path { path in
                        guard let first = points.first else { return }

                        let bottomY = height - bottomPadding
                        let topY = topPadding

                        func y(for value: CGFloat) -> CGFloat {
                            let clamped = max(0, min(1, value))
                            return bottomY - clamped * (bottomY - topY)
                        }

                        path.move(
                            to: CGPoint(
                                x: leftPadding,
                                y: y(for: first)
                            )
                        )

                        for (index, value) in points.enumerated() {
                            let x = leftPadding + CGFloat(index) * stepX
                            path.addLine(to: CGPoint(x: x, y: y(for: value)))
                        }
                    }
                    .stroke(
                        Color(hex: "FF4991"),
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )

                    VStack {
                        Spacer()
                        HStack(spacing: 0) {
                            ForEach(1...30, id: \.self) { day in
                                Text("\(day)")
                                    .font(.system(size: Device.isSmall ? 5 : 6))
                                    .foregroundColor(Color(hex: "B9AEB4"))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.leading, leftPadding)
                        .padding(.trailing, rightPadding)
                        .padding(.bottom, 2)
                    }
                }
            }
        }
        .frame(height: 180)
    }
}

#Preview {
    Profile {}
}
