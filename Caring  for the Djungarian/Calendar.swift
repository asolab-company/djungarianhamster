import Foundation
import SwiftUI
import UserNotifications

struct CalendarView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var showScheduleOverlay: Bool = false

    @State private var selectedScheduleDate: String = ""

    @State private var selectedScheduleEventIndices: Set<Int> = []

    @State private var notificationsOn: Bool = false

    @State private var calendarSelectedDate: Date? = Date()

    @State private var scheduleItems: [ScheduleItem] = []

    private let scheduleEvents: [String] = [
        "Add Food",
        "Add Water",
        "Clean The Cage",
        "Wash The Cage",
        "Visit The Vet - Recommended Once A Year",
    ]
    var onClose: () -> Void

    private var scheduleDateFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "dd.MM.yyyy"
        return df
    }

    private var isScheduleDateValid: Bool {
        guard
            scheduleDateFormatter.date(
                from: selectedScheduleDate.trimmingCharacters(in: .whitespaces)
            ) != nil
        else {
            return false
        }
        return true
    }

    private var canSaveSchedule: Bool {
        isScheduleDateValid && !selectedScheduleEventIndices.isEmpty
    }

    private var plannedEventsForSelectedDate: [String] {
        guard let selectedDate = calendarSelectedDate else { return [] }

        let center = Calendar.current

        let itemsForDay = scheduleItems.filter { item in
            center.isDate(item.date, inSameDayAs: selectedDate)
        }

        var seen = Set<String>()
        var result: [String] = []
        for event in itemsForDay.flatMap({ $0.events }) {
            if !seen.contains(event) {
                seen.insert(event)
                result.append(event)
            }
        }
        return result
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
                            .stroke(Color(hex: "FED3E4"), lineWidth: 2)

                        )

                    VStack(spacing: 16) {

                        Text("Calendar")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(Color(hex: "60434D"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)

                        MonthCalendarView(selectedDate: $calendarSelectedDate)

                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 12) {
                                if plannedEventsForSelectedDate.isEmpty {
                                    Text("No events planned for this day.")
                                        .font(
                                            .system(size: 15, weight: .regular)
                                        )
                                        .foregroundColor(
                                            Color(hex: "60434D").opacity(0.7)
                                        )
                                } else {
                                    Text("Planned:")
                                        .font(
                                            .system(size: 20, weight: .semibold)
                                        )
                                        .foregroundColor(Color(hex: "60434D"))

                                    ForEach(
                                        plannedEventsForSelectedDate,
                                        id: \.self
                                    ) { event in
                                        HStack(alignment: .top, spacing: 8) {
                                            Text("•")
                                                .font(
                                                    .system(
                                                        size: 18,
                                                        weight: .bold
                                                    )
                                                )
                                                .foregroundColor(
                                                    Color(hex: "60434D")
                                                )

                                            Text(event)
                                                .font(
                                                    .system(
                                                        size: 18,
                                                        weight: .regular
                                                    )
                                                )
                                                .foregroundColor(
                                                    Color(hex: "60434D")
                                                )
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 8)
                        }

                        Button(action: {
                            prepareScheduleOverlayForCurrentDate()
                        }) {
                            Text("Shedule An Event")
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

            if showScheduleOverlay {
                ZStack(alignment: .top) {

                    Color.init(hex: "60434D")
                        .opacity(0.47)
                        .ignoresSafeArea()

                    VStack(spacing: 10) {
                        HStack {
                            Button {

                                showScheduleOverlay = false
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
                        ZStack {

                            RoundedRectangle(
                                cornerRadius: 32,
                                style: .continuous
                            )
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(
                                    cornerRadius: 32,
                                    style: .continuous
                                )
                                .stroke(Color(hex: "FED3E4"), lineWidth: 2)

                            )

                            VStack(spacing: 20) {

                                Text("Schedule an Event")
                                    .font(.system(size: 26, weight: .semibold))
                                    .foregroundColor(Color(hex: "60434D"))
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .center
                                    )

                                ScrollView(showsIndicators: false) {
                                    VStack(alignment: .leading, spacing: 24) {

                                        VStack(alignment: .leading, spacing: 8)
                                        {
                                            Text("Select Date")
                                                .font(
                                                    .system(
                                                        size: 18,
                                                        weight: .medium
                                                    )
                                                )
                                                .foregroundColor(
                                                    Color(hex: "60434D")
                                                )

                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(
                                                    cornerRadius: 32,
                                                    style: .continuous
                                                )
                                                .stroke(
                                                    Color(hex: "FFC4DD"),
                                                    lineWidth: 2
                                                )
                                                .background(
                                                    RoundedRectangle(
                                                        cornerRadius: 32,
                                                        style: .continuous
                                                    )
                                                    .fill(Color.white)
                                                )
                                                .frame(height: 50)

                                                TextField(
                                                    "DD.MM.YYYY",
                                                    text: $selectedScheduleDate
                                                )
                                                .font(
                                                    .system(
                                                        size: 18,
                                                        weight: .regular
                                                    )
                                                )
                                                .foregroundColor(
                                                    Color(hex: "60434D")
                                                )
                                                .padding(.horizontal, 20)
                                                .keyboardType(
                                                    .numbersAndPunctuation
                                                )
                                                .onChange(
                                                    of: selectedScheduleDate
                                                ) { newValue in
                                                    formatScheduleDateInput(
                                                        newValue
                                                    )
                                                }
                                            }
                                        }

                                        VStack(alignment: .leading, spacing: 16)
                                        {
                                            Text("Select event")
                                                .font(
                                                    .system(
                                                        size: 18,
                                                        weight: .medium
                                                    )
                                                )
                                                .foregroundColor(
                                                    Color(hex: "60434D")
                                                )

                                            ForEach(
                                                scheduleEvents.indices,
                                                id: \.self
                                            ) { index in
                                                let title = scheduleEvents[
                                                    index
                                                ]
                                                let isSelected =
                                                    selectedScheduleEventIndices
                                                    .contains(index)

                                                HStack(spacing: 12) {
                                                    ZStack {
                                                        Circle()
                                                            .stroke(
                                                                Color(
                                                                    hex:
                                                                        "FFC4DD"
                                                                ),
                                                                lineWidth: 2
                                                            )
                                                            .frame(
                                                                width: 22,
                                                                height: 22
                                                            )
                                                            .background(
                                                                Circle()
                                                                    .fill(
                                                                        isSelected
                                                                            ? Color(
                                                                                hex:
                                                                                    "FF7BAB"
                                                                            )
                                                                            : Color
                                                                                .clear
                                                                    )
                                                            )

                                                        if isSelected {
                                                            Image(
                                                                systemName:
                                                                    "checkmark"
                                                            )
                                                            .font(
                                                                .system(
                                                                    size: 10,
                                                                    weight:
                                                                        .bold
                                                                )
                                                            )
                                                            .foregroundColor(
                                                                .white
                                                            )
                                                        }
                                                    }

                                                    Text(title)
                                                        .font(
                                                            .system(
                                                                size: 15,
                                                                weight: .medium
                                                            )
                                                        )
                                                        .foregroundColor(
                                                            Color(hex: "60434D")
                                                        )

                                                    Spacer()
                                                }
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                    if selectedScheduleEventIndices
                                                        .contains(index)
                                                    {
                                                        selectedScheduleEventIndices
                                                            .remove(index)
                                                    } else {
                                                        selectedScheduleEventIndices
                                                            .insert(index)
                                                    }
                                                }
                                            }
                                        }

                                        VStack(alignment: .leading, spacing: 12)
                                        {
                                            Text("Notifications:")
                                                .font(
                                                    .system(
                                                        size: 18,
                                                        weight: .medium
                                                    )
                                                )
                                                .foregroundColor(
                                                    Color(hex: "60434D")
                                                )

                                            ZStack {
                                                RoundedRectangle(
                                                    cornerRadius: 28,
                                                    style: .continuous
                                                )
                                                .fill(Color(hex: "FFEAF2"))
                                                .frame(width: 180, height: 40)

                                                HStack(spacing: 0) {
                                                    Button {
                                                        notificationsOn = true
                                                    } label: {
                                                        ZStack {
                                                            if notificationsOn {
                                                                LinearGradient(
                                                                    colors: [
                                                                        Color(
                                                                            hex:
                                                                                "FF6AA8"
                                                                        ),
                                                                        Color(
                                                                            hex:
                                                                                "FF3F8F"
                                                                        ),
                                                                    ],
                                                                    startPoint:
                                                                        .leading,
                                                                    endPoint:
                                                                        .trailing
                                                                )
                                                                .clipShape(
                                                                    RoundedRectangle(
                                                                        cornerRadius:
                                                                            24,
                                                                        style:
                                                                            .continuous
                                                                    )
                                                                )
                                                            }

                                                            Text("On")
                                                                .font(
                                                                    .system(
                                                                        size:
                                                                            18,
                                                                        weight:
                                                                            .semibold
                                                                    )
                                                                )
                                                                .foregroundColor(
                                                                    notificationsOn
                                                                        ? .white
                                                                        : Color(
                                                                            hex:
                                                                                "60434D"
                                                                        )
                                                                )
                                                        }
                                                    }
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        maxHeight: .infinity
                                                    )

                                                    Button {
                                                        notificationsOn = false
                                                    } label: {
                                                        ZStack {
                                                            if !notificationsOn
                                                            {
                                                                LinearGradient(
                                                                    colors: [
                                                                        Color(
                                                                            hex:
                                                                                "FF6AA8"
                                                                        ),
                                                                        Color(
                                                                            hex:
                                                                                "FF3F8F"
                                                                        ),
                                                                    ],
                                                                    startPoint:
                                                                        .leading,
                                                                    endPoint:
                                                                        .trailing
                                                                )
                                                                .clipShape(
                                                                    RoundedRectangle(
                                                                        cornerRadius:
                                                                            24,
                                                                        style:
                                                                            .continuous
                                                                    )
                                                                )
                                                            }

                                                            Text("Off")
                                                                .font(
                                                                    .system(
                                                                        size:
                                                                            18,
                                                                        weight:
                                                                            .semibold
                                                                    )
                                                                )
                                                                .foregroundColor(
                                                                    !notificationsOn
                                                                        ? .white
                                                                        : Color(
                                                                            hex:
                                                                                "60434D"
                                                                        )
                                                                )
                                                        }
                                                    }
                                                    .frame(
                                                        maxWidth: .infinity,
                                                        maxHeight: .infinity
                                                    )
                                                }
                                                .frame(width: 180, height: 40)
                                                .padding(4)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 1)
                                }

                                Button(action: {
                                    handleSaveSchedule()
                                }) {
                                    Text("Save")
                                        .font(
                                            .system(size: 20, weight: .semibold)
                                        )
                                        .foregroundColor(.white)
                                        .frame(
                                            maxWidth: .infinity,
                                            minHeight: 60
                                        )
                                        .background(
                                            LinearGradient(
                                                colors: [
                                                    Color(hex: "FED3E4"),
                                                    Color(hex: "FF4991"),
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                            .opacity(
                                                canSaveSchedule ? 1.0 : 0.4
                                            )
                                        )
                                        .clipShape(Capsule())
                                }
                                .disabled(!canSaveSchedule)
                            }
                            .padding(.vertical)
                            .padding(.horizontal, 26)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .top
                    )

                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.white).ignoresSafeArea()
        )
        .onAppear {
            loadScheduleItems()
        }
    }

    private func resetScheduleOverlayFields() {
        selectedScheduleDate = ""
        selectedScheduleEventIndices.removeAll()
        notificationsOn = false
    }

    private func prepareScheduleOverlayForCurrentDate() {
        let calendar = Calendar.current

        guard let selectedDate = calendarSelectedDate else {

            resetScheduleOverlayFields()
            showScheduleOverlay = true
            return
        }

        selectedScheduleDate = scheduleDateFormatter.string(from: selectedDate)

        let itemsForDay = scheduleItems.filter { item in
            calendar.isDate(item.date, inSameDayAs: selectedDate)
        }

        if let existing = itemsForDay.last {

            notificationsOn = existing.notificationsOn

            var indices = Set<Int>()
            for event in existing.events {
                if let idx = scheduleEvents.firstIndex(of: event) {
                    indices.insert(idx)
                }
            }
            selectedScheduleEventIndices = indices
        } else {

            selectedScheduleEventIndices.removeAll()
            notificationsOn = false
        }

        showScheduleOverlay = true
    }

    private struct ScheduleItem: Codable, Identifiable {
        let id: UUID
        let date: Date
        let events: [String]
        let notificationsOn: Bool
    }

    private var scheduleStorageKey: String { "ScheduleItems" }

    private func parseScheduleDate() -> Date? {
        scheduleDateFormatter.date(
            from: selectedScheduleDate.trimmingCharacters(in: .whitespaces)
        )
    }

    private func formatScheduleDateInput(_ value: String) {

        let digits = value.filter { $0.isNumber }.prefix(8)
        var result = ""

        for (index, char) in digits.enumerated() {
            if index == 2 || index == 4 {
                result.append(".")
            }
            result.append(char)
        }

        if result != selectedScheduleDate {
            selectedScheduleDate = result
        }
    }

    private func handleSaveSchedule() {
        guard let date = parseScheduleDate(),
            !selectedScheduleEventIndices.isEmpty
        else {
            return
        }

        let selectedEvents = selectedScheduleEventIndices.sorted().map {
            scheduleEvents[$0]
        }

        let item = ScheduleItem(
            id: UUID(),
            date: date,
            events: selectedEvents,
            notificationsOn: notificationsOn
        )

        var existing: [ScheduleItem] = []
        if let data = UserDefaults.standard.data(forKey: scheduleStorageKey),
            let decoded = try? JSONDecoder().decode(
                [ScheduleItem].self,
                from: data
            )
        {
            existing = decoded
        }

        existing.append(item)

        if let encoded = try? JSONEncoder().encode(existing) {
            UserDefaults.standard.set(encoded, forKey: scheduleStorageKey)
        }

        loadScheduleItems()

        if notificationsOn {
            scheduleNotification(for: date, events: selectedEvents)
        }

        showScheduleOverlay = false
        resetScheduleOverlayFields()
    }

    private func loadScheduleItems() {
        guard let data = UserDefaults.standard.data(forKey: scheduleStorageKey),
            let decoded = try? JSONDecoder().decode(
                [ScheduleItem].self,
                from: data
            )
        else {
            scheduleItems = []
            return
        }
        scheduleItems = decoded
    }

    private func scheduleNotification(for date: Date, events: [String]) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }

            let content = UNMutableNotificationContent()
            content.title = "Schedule Reminder"
            if events.isEmpty {
                content.body = "You have a scheduled event today."
            } else {
                content.body = events.joined(separator: ", ")
            }
            content.sound = .default

            var components = Calendar.current.dateComponents(
                [.year, .month, .day],
                from: date
            )
            components.hour = 9
            components.minute = 0

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false
            )

            let request = UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            )

            center.add(request, withCompletionHandler: nil)
        }
    }
}

private struct MonthCalendarView: View {
    @Binding var selectedDate: Date?
    @State private var displayedMonth: Date = Date()

    private var calendar: Foundation.Calendar {
        var cal = Foundation.Calendar.current
        cal.firstWeekday = 2

        return cal
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "LLLL yy"
        return formatter.string(from: displayedMonth)
    }

    private var daysMatrix: [[Int?]] {
        let components = calendar.dateComponents(
            [.year, .month],
            from: displayedMonth
        )
        guard let firstOfMonth = calendar.date(from: components),
            let range = calendar.range(of: .day, in: .month, for: firstOfMonth)
        else {
            return []
        }

        let dayCount = range.count

        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let firstDayIndex = (weekday + 5) % 7

        let leadingEmpty = firstDayIndex
        let totalCells = leadingEmpty + dayCount
        let rows = Int(ceil(Double(totalCells) / 7.0))

        var result: [[Int?]] = []
        var currentDay = 1

        for row in 0..<rows {
            var rowArray: [Int?] = []
            for col in 0..<7 {
                let index = row * 7 + col
                if index < leadingEmpty || index >= leadingEmpty + dayCount {
                    rowArray.append(nil)
                } else {
                    rowArray.append(currentDay)
                    currentDay += 1
                }
            }
            result.append(rowArray)
        }

        return result
    }

    private let weekdaySymbols: [String] = [
        "Mon", "Tue", "Wen", "Thu", "Fri", "Sat", "Sun",
    ]

    private func dateFor(day: Int) -> Date? {
        var components = calendar.dateComponents(
            [.year, .month],
            from: displayedMonth
        )
        components.day = day
        return calendar.date(from: components)
    }

    var body: some View {
        VStack(spacing: 14) {

            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }

                Spacer()

                Text(monthTitle)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }

            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(maxWidth: .infinity)
                }
            }

            VStack(spacing: 13) {
                ForEach(0..<daysMatrix.count, id: \.self) { row in
                    HStack {
                        ForEach(0..<7, id: \.self) { col in
                            let value = daysMatrix[row][col]

                            if let day = value {
                                let date = dateFor(day: day)
                                let isToday =
                                    date.map { calendar.isDateInToday($0) }
                                    ?? false
                                let isSelected: Bool = {
                                    guard let selected = selectedDate,
                                        let d = date
                                    else { return false }
                                    return calendar.isDate(
                                        selected,
                                        inSameDayAs: d
                                    )
                                }()

                                ZStack {
                                    if isSelected {
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                            .frame(width: 22, height: 22)
                                    } else if isToday {
                                        Circle()
                                            .stroke(
                                                Color.white.opacity(0.7),
                                                lineWidth: 1.5
                                            )
                                            .frame(width: 22, height: 22)
                                    }

                                    Text(String(day))
                                        .font(
                                            .system(size: 14, weight: .regular)
                                        )
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if let d = date {
                                        selectedDate = d
                                    }
                                }
                            } else {
                                Text("")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(Color(hex: "FFB4D0"))

        )
        .onAppear {

            let today = Date()
            if selectedDate == nil {
                if calendar.isDate(
                    today,
                    equalTo: displayedMonth,
                    toGranularity: .month
                ) {
                    selectedDate = today
                }
            }
        }
    }

    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(
            byAdding: .month,
            value: value,
            to: displayedMonth
        ) {
            displayedMonth = newDate
        }
    }
}

#Preview {
    CalendarView {}
}
