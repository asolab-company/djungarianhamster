import SwiftUI

// MARK: - UserDefaults Keys

private let kDailyListSavedDateKey = "DailyList.savedDate"
private let kDailyListAddWaterKey = "DailyList.addWater"
private let kDailyListAddFoodKey = "DailyList.addFood"
private let kDailyListRemoveVegKey = "DailyList.removeVeg"
private let kDailyListRemoveFecesKey = "DailyList.removeFeces"
private let kDailyListPlayHamsterKey = "DailyList.playHamster"
private let kDailyListNotesKey = "DailyList.notes"
private let kDailyListMoodKey = "DailyList.mood"

struct DailyList: View {

    @Environment(\.dismiss) private var dismiss
    var onClose: () -> Void
    // чекбоксы
    @State private var addWater = false
    @State private var addFood = false
    @State private var removeVeg = false
    @State private var removeFeces = false
    @State private var playHamster = false

    // состояние хомячка
    enum HamsterMood: Int {
        case nice = 0
        case good = 1
        case bad = 2
    }
    @State private var selectedMood: HamsterMood? = nil

    // заметки
    @State private var notes: String = ""

    // MARK: - Persistence
    private func loadFromDefaults() {
        let defaults = UserDefaults.standard
        let today = Calendar.current.startOfDay(for: Date())

        if let savedDate = defaults.object(forKey: kDailyListSavedDateKey)
            as? Date
        {
            if Calendar.current.isDate(savedDate, inSameDayAs: today) {
                // same day – restore daily checklist
                addWater = defaults.bool(forKey: kDailyListAddWaterKey)
                addFood = defaults.bool(forKey: kDailyListAddFoodKey)
                removeVeg = defaults.bool(forKey: kDailyListRemoveVegKey)
                removeFeces = defaults.bool(forKey: kDailyListRemoveFecesKey)
                playHamster = defaults.bool(forKey: kDailyListPlayHamsterKey)
                notes = defaults.string(forKey: kDailyListNotesKey) ?? ""
            } else {
                // new day – clear daily checklist
                addWater = false
                addFood = false
                removeVeg = false
                removeFeces = false
                playHamster = false
                notes = ""
            }
        } else {
            // first launch – clear daily checklist
            addWater = false
            addFood = false
            removeVeg = false
            removeFeces = false
            playHamster = false
            notes = ""
        }

        // mood is stored separately and kept forever
        if defaults.object(forKey: kDailyListMoodKey) != nil {
            let raw = defaults.integer(forKey: kDailyListMoodKey)
            selectedMood = HamsterMood(rawValue: raw)
        }
    }

    private func saveToDefaults() {
        let defaults = UserDefaults.standard
        let today = Calendar.current.startOfDay(for: Date())

        // save date for 1-day validity of checklist
        defaults.set(today, forKey: kDailyListSavedDateKey)

        // save daily checklist (valid only for this day)
        defaults.set(addWater, forKey: kDailyListAddWaterKey)
        defaults.set(addFood, forKey: kDailyListAddFoodKey)
        defaults.set(removeVeg, forKey: kDailyListRemoveVegKey)
        defaults.set(removeFeces, forKey: kDailyListRemoveFecesKey)
        defaults.set(playHamster, forKey: kDailyListPlayHamsterKey)
        defaults.set(notes, forKey: kDailyListNotesKey)

        // save mood separately – stored forever
        if let mood = selectedMood {
            defaults.set(mood.rawValue, forKey: kDailyListMoodKey)
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
                    // 🔲 Карточка
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 32,
                                style: .continuous
                            )
                            .stroke(Color(hex: "FED3E4"), lineWidth: 1)  // твоя рамка
                        )

                    VStack(spacing: 16) {

                        Text("Daily To-do list")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color(hex: "60434D"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        // 🔹 Контент
                        ScrollView(.vertical, showsIndicators: false) {

                            VStack(spacing: 12) {
                                // MARK: - Чекбоксы
                                CheckRow(
                                    title: "Add Water To The Drinking Cup",
                                    isOn: $addWater
                                )
                                CheckRow(
                                    title: "Add Food To The Feeder",
                                    isOn: $addFood
                                )
                                CheckRow(
                                    title:
                                        "Remove Any Remaining Vegetables/Fruits",
                                    isOn: $removeVeg
                                )
                                CheckRow(
                                    title: "Remove Feces",
                                    isOn: $removeFeces
                                )
                                CheckRow(
                                    title: "Play With The Hamster",
                                    isOn: $playHamster
                                )

                                // MARK: - Mark condition
                                Text("Mark the condition of the hamster:")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color(hex: "60434D"))
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )

                                MoodSelector(selectedMood: $selectedMood)

                                // MARK: - Notes
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

private struct MoodSelector: View {
    @Binding var selectedMood: DailyList.HamsterMood?

    var body: some View {
        HStack(spacing: 0) {
            moodButton(
                mood: .nice,
                text: "Nice!",
                emoji: "😋"
            )
            moodButton(
                mood: .good,
                text: "Good!",
                emoji: "😊"
            )
            moodButton(
                mood: .bad,
                text: "Bad!",
                emoji: "😠"
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color(hex: "FFC1DF"), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color(hex: "FFEAF2"))
                )
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
        )
    }

    @ViewBuilder
    private func moodButton(
        mood: DailyList.HamsterMood,
        text: String,
        emoji: String
    ) -> some View {
        let isSelected = (selectedMood == mood)

        Button {
            selectedMood = mood
        } label: {
            HStack(spacing: 6) {
                Text(emoji)
                    .font(.system(size: 20))
                Text(text)
                    .font(.system(size: 18, weight: .semibold))
            }
            .foregroundColor(
                isSelected
                    ? .white
                    : Color(hex: "60434D")
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "FED3E4"),
                        Color(hex: "FF4991"),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .opacity(isSelected ? 1 : 0)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DailyList {}
}
