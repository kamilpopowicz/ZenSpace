import Foundation
import SwiftUI
import EventKit

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var todayEvents: [CalendarEvent] = []
    @Published var tomorrowEvents: [CalendarEvent] = []
    @Published var hasAccess: Bool = false
    @Published var isLoading: Bool = false

    @AppStorage("calendarEnabled") private var calendarEnabled = true

    private let service = CalendarService()

    var todaySection: EventSection {
        EventSection(title: "Today", events: todayEvents)
    }

    var tomorrowSection: EventSection {
        EventSection(title: "Tomorrow", events: tomorrowEvents)
    }

    var isEnabled: Bool { calendarEnabled }

    func requestAccess() async {
        hasAccess = await service.requestAccess()
        if hasAccess { loadEvents() }
    }

    func loadEvents() {
        guard calendarEnabled else {
            todayEvents = []
            tomorrowEvents = []
            return
        }
        isLoading = true
        todayEvents = service.fetchTodayEvents()
        tomorrowEvents = service.fetchTomorrowEvents()
        isLoading = false
    }

    func checkAccess() {
        hasAccess = service.authorizationStatus == .authorized
    }
}
