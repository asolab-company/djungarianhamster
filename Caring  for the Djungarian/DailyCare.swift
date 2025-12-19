import SwiftUI

struct DailyCare: View {

    @Environment(\.dismiss) private var dismiss
    @State private var showDetails = false

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
                .padding(.top, 10)
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

                        Text("Daily care")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color(hex: "60434D"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        ScrollView(.vertical, showsIndicators: false) {
                            Image("bg_hamster")
                                .resizable()
                                .scaledToFit()
                            VStack(alignment: .leading, spacing: 16) {

                                Text("Recommendations:")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(hex: "60434D"))

                                VStack(alignment: .leading, spacing: 10) {

                                    HStack(alignment: .top, spacing: 10) {
                                        Text("•")
                                            .font(.system(size: 20))
                                            .foregroundColor(
                                                Color(hex: "60434D")
                                            )

                                        Text(
                                            "Room temperature: keep within 20–24ºC."
                                        )
                                        .font(
                                            .system(size: 16, weight: .medium)
                                        )
                                        .foregroundColor(Color(hex: "60434D"))
                                    }

                                    HStack(alignment: .top, spacing: 10) {
                                        Text("•")
                                            .font(.system(size: 20))
                                            .foregroundColor(
                                                Color(hex: "60434D")
                                            )

                                        Text("No drafts or direct sunlight.")
                                            .font(
                                                .system(
                                                    size: 16,
                                                    weight: .medium
                                                )
                                            )
                                            .foregroundColor(
                                                Color(hex: "60434D")
                                            )
                                    }

                                    HStack(alignment: .top, spacing: 10) {
                                        Text("•")
                                            .font(.system(size: 20))
                                            .foregroundColor(
                                                Color(hex: "60434D")
                                            )

                                        Text(
                                            "Vegetables and fruits – can be given no more than 1–2 times a week, in small quantities."
                                        )
                                        .font(
                                            .system(size: 16, weight: .medium)
                                        )
                                        .foregroundColor(Color(hex: "60434D"))
                                    }

                                    HStack(alignment: .top, spacing: 10) {
                                        Text("•")
                                            .font(.system(size: 20))
                                            .foregroundColor(
                                                Color(hex: "60434D")
                                            )

                                        Text(
                                            "Never bathe in water – only sand baths."
                                        )
                                        .font(
                                            .system(size: 16, weight: .medium)
                                        )
                                        .foregroundColor(Color(hex: "60434D"))
                                    }

                                }
                            }
                        }

                        Button(action: { showDetails = true }) {
                            Text("Daily To-Do List")
                                .font(.system(size: 20, weight: .semibold))
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
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 26)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.white).ignoresSafeArea()
        )
        .fullScreenCover(isPresented: $showDetails) {
            DailyList { onClose() }
        }

    }

}

#Preview {
    DailyCare {}
}
