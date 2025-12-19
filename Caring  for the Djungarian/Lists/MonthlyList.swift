import SwiftUI

private let kMonthlyListSavedDateKey = "MonthlyList.savedDate"
private let kMonthlyListCompleteBeddingKey = "MonthlyList.completeBedding"
private let kMonthlyListCompleteFeedKey = "MonthlyList.completeFeed"
private let kMonthlyListWashCageKey = "MonthlyList.washCage"
private let kMonthlyListWashBowlsKey = "MonthlyList.washBowls"
private let kMonthlyListFurCleaningKey = "MonthlyList.furCleaning"
private let kMonthlyListNotesKey = "MonthlyList.notes"
private let kMonthlyListMoodKey = "MonthlyList.mood"

struct MonthlyList: View {

    @Environment(\.dismiss) private var dismiss
    var onClose: () -> Void

    @State private var addWater = false
    @State private var addFood = false
    @State private var removeVeg = false
    @State private var removeFeces = false
    @State private var playHamster = false

    enum HamsterMood: Int {
        case nice = 0
        case good = 1
        case bad = 2
    }
    @State private var selectedMood: HamsterMood? = nil

    @State private var notes: String = ""

    private func loadFromDefaults() {
        let defaults = UserDefaults.standard
        let now = Date()

        if let savedDate = defaults.object(forKey: kMonthlyListSavedDateKey)
            as? Date
        {
            let interval = now.timeIntervalSince(savedDate)
            let month: TimeInterval = 30 * 24 * 60 * 60

            if interval < month {

                addWater = defaults.bool(forKey: kMonthlyListCompleteBeddingKey)
                addFood = defaults.bool(forKey: kMonthlyListCompleteFeedKey)
                removeVeg = defaults.bool(forKey: kMonthlyListWashCageKey)
                removeFeces = defaults.bool(forKey: kMonthlyListWashBowlsKey)
                playHamster = defaults.bool(forKey: kMonthlyListFurCleaningKey)
                notes = defaults.string(forKey: kMonthlyListNotesKey) ?? ""
            } else {

                addWater = false
                addFood = false
                removeVeg = false
                removeFeces = false
                playHamster = false
                notes = ""
            }
        } else {

            addWater = false
            addFood = false
            removeVeg = false
            removeFeces = false
            playHamster = false
            notes = ""
        }

        if defaults.object(forKey: kMonthlyListMoodKey) != nil {
            let raw = defaults.integer(forKey: kMonthlyListMoodKey)
            selectedMood = HamsterMood(rawValue: raw)
        }
    }

    private func saveToDefaults() {
        let defaults = UserDefaults.standard
        let now = Date()

        defaults.set(now, forKey: kMonthlyListSavedDateKey)

        defaults.set(addWater, forKey: kMonthlyListCompleteBeddingKey)
        defaults.set(addFood, forKey: kMonthlyListCompleteFeedKey)
        defaults.set(removeVeg, forKey: kMonthlyListWashCageKey)
        defaults.set(removeFeces, forKey: kMonthlyListWashBowlsKey)
        defaults.set(playHamster, forKey: kMonthlyListFurCleaningKey)
        defaults.set(notes, forKey: kMonthlyListNotesKey)

        if let mood = selectedMood {
            defaults.set(mood.rawValue, forKey: kMonthlyListMoodKey)
        }
    }

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
                            .stroke(Color(hex: "FED3E4"), lineWidth: 1)

                        )

                    VStack(spacing: 16) {

                        Text("Monthly care")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color(hex: "60434D"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        ScrollView(.vertical, showsIndicators: false) {

                            VStack(spacing: 12) {
                                Text("Notes:")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(hex: "60434D"))
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )

                                CheckRow(
                                    title: "Complete bedding change",
                                    isOn: $addWater
                                )
                                CheckRow(
                                    title: "Complete feed replacement",
                                    isOn: $addFood
                                )
                                CheckRow(
                                    title: "Washing the cage with soap",
                                    isOn: $removeVeg
                                )
                                CheckRow(
                                    title: "Washing bowls with soap",
                                    isOn: $removeFeces
                                )
                                CheckRow(
                                    title:
                                        "Cleaning a hamster's fur (sand bath)",
                                    isOn: $playHamster
                                )

                                Text("Notes:")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(hex: "60434D"))
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )

                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(
                                        cornerRadius: 24,
                                        style: .continuous
                                    )
                                    .fill(Color(hex: "FFEAF2"))

                                    TextEditor(text: $notes)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(hex: "60434D"))
                                        .scrollContentBackground(.hidden)
                                        .background(Color.clear)
                                }
                                .frame(minHeight: 140)
                            }
                        }

                        Button(action: {
                            saveToDefaults()
                        }) {
                            Text("Save")
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
        .onAppear {
            loadFromDefaults()
        }
    }

}

private struct CheckRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(Color(hex: "FFC1DF"), lineWidth: 1)
                        .frame(width: 23, height: 23)

                    if isOn {
                        Circle()
                            .fill(Color(hex: "FFC1DF"))
                            .frame(width: 23, height: 23)

                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "60434D"))
                    .multilineTextAlignment(.leading)

                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding(2)
    }
}

#Preview {
    MonthlyList {}
}
