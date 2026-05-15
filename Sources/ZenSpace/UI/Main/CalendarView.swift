import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.hasAccess {
                calendarPermissionView
            } else if viewModel.todayEvents.isEmpty && viewModel.tomorrowEvents.isEmpty {
                emptyView
            } else {
                eventsListView
            }
        }
        .task {
            viewModel.checkAccess()
            if viewModel.hasAccess {
                viewModel.loadEvents()
            }
        }
    }

    private var calendarPermissionView: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.title2)
                .foregroundStyle(.secondary)
            Text(String(format: L("onboarding.calendar.permissionDescription"), AppConstants.APP_NAME))
                .font(.caption)
                .multilineTextAlignment(.center)
            Button(L("onboarding.accessibility.grantPermission")) {
                Task { await viewModel.requestAccess() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    private var emptyView: some View {
        VStack(spacing: 4) {
            Image(systemName: "calendar")
                .font(.title3)
                .foregroundStyle(.secondary)
            Text(L("calendar.empty.yourDayIsClear"))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    private var eventsListView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !viewModel.todayEvents.isEmpty {
                sectionView(title: "TODAY", events: viewModel.todayEvents)
            }
            if !viewModel.tomorrowEvents.isEmpty {
                Divider()
                sectionView(title: L("calendar.section.tomorrowFull"), events: viewModel.tomorrowEvents)
            }
        }
    }

    private func sectionView(title: String, events: [CalendarEvent]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ForEach(events) { event in
                EventRowView(event: event)
            }
        }
    }
}

struct EventRowView: View {
    let event: CalendarEvent

    var body: some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 2)
                .fill(eventColor)
                .frame(width: 3, height: 28)

            VStack(alignment: .leading, spacing: 1) {
                Text(event.title)
                    .font(.caption)
                    .lineLimit(1)

                if event.isAllDay {
                    Text("All Day")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                } else {
                    Text(timeRange)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .opacity(event.isPast ? 0.5 : 1.0)
    }

    private var eventColor: Color {
        if let hex = event.calendarColor {
            return Color(hex: hex)
        }
        return .accentColor
    }

    private var timeRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: event.startDate)) – \(formatter.string(from: event.endDate))"
    }
}

// MARK: - Color hex extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
