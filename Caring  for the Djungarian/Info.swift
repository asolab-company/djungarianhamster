import SwiftUI

struct Info: View {

    @Environment(\.openURL) private var openURL
    @Environment(\.dismiss) private var dismiss
    private let rateURL = URL(
        string: "https://apps.apple.com/app/id6756789418"
    )!
    private let termsURL = URL(string: "https://docs.google.com/document/d/e/2PACX-1vSyLqq_nkAagoTWwM9RsLLD-72x8QGHHwk1isoXGNt9gINQBsspuqGyw5ShRAmZ-zJzkcgU7zit-O5N/pub")!
    private let privacyURL = URL(string: "https://docs.google.com/document/d/e/2PACX-1vSyLqq_nkAagoTWwM9RsLLD-72x8QGHHwk1isoXGNt9gINQBsspuqGyw5ShRAmZ-zJzkcgU7zit-O5N/pub")!
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

                        Text("Info")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color(hex: "60434D"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        Button(action: { openURL(rateURL) }) {
                            Text("Rate This App")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 65)
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

                        Button(action: { openURL(termsURL) }) {
                            Text("Terms Of Use")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 65)
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

                        Button(action: { openURL(privacyURL) }) {
                            Text("Privacy Policy")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, minHeight: 65)
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

                        Spacer()
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

#Preview {
    Info {}
}
