import SwiftUI

private let kWeeklyListSavedDateKey = "WeeklyList.savedDate"
private let kWeeklyListPartialLitterKey = "WeeklyList.partialLitter"
private let kWeeklyListWaterChangeKey = "WeeklyList.waterChange"
private let kWeeklyListWashDishesKey = "WeeklyList.washDishes"
private let kWeeklyListAddToyKey = "WeeklyList.addToy"
private let kWeeklyListNotesKey = "WeeklyList.notes"
private let kWeeklyListMoodKey = "WeeklyList.mood"

struct WeeklyList: View {

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

        if let savedDate = defaults.object(forKey: kWeeklyListSavedDateKey)
            as? Date
        {
            let interval = now.timeIntervalSince(savedDate)
            let week: TimeInterval = 7 * 24 * 60 * 60

            if interval < week {

                addWater = defaults.bool(forKey: kWeeklyListPartialLitterKey)
                addFood = defaults.bool(forKey: kWeeklyListWaterChangeKey)
                removeVeg = defaults.bool(forKey: kWeeklyListWashDishesKey)
                removeFeces = defaults.bool(forKey: kWeeklyListAddToyKey)

                playHamster = false
                notes = defaults.string(forKey: kWeeklyListNotesKey) ?? ""
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

        if defaults.object(forKey: kWeeklyListMoodKey) != nil {
            let raw = defaults.integer(forKey: kWeeklyListMoodKey)
            selectedMood = HamsterMood(rawValue: raw)
        }
    }

    private func saveToDefaults() {
        let defaults = UserDefaults.standard
        let now = Date()

        defaults.set(now, forKey: kWeeklyListSavedDateKey)

        defaults.set(addWater, forKey: kWeeklyListPartialLitterKey)
        defaults.set(addFood, forKey: kWeeklyListWaterChangeKey)
        defaults.set(removeVeg, forKey: kWeeklyListWashDishesKey)
        defaults.set(removeFeces, forKey: kWeeklyListAddToyKey)
        defaults.set(notes, forKey: kWeeklyListNotesKey)

        if let mood = selectedMood {
            defaults.set(mood.rawValue, forKey: kWeeklyListMoodKey)
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

                        Text("Weekly care")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color(hex: "60434D"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        ScrollView(.vertical, showsIndicators: false) {

                            VStack(spacing: 12) {

                                CheckRow(
                                    title: "Partial replacement of litter",
                                    isOn: $addWater
                                )
                                CheckRow(
                                    title: "Complete water change",
                                    isOn: $addFood
                                )
                                CheckRow(
                                    title:
                                        "Washing the sippy cup and bowls with soap",
                                    isOn: $removeVeg
                                )
                                CheckRow(
                                    title: "Add a teething toy",
                                    isOn: $removeFeces
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
    WeeklyList {}
}
