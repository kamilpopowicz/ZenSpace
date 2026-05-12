import Foundation
import SwiftUI
import EventKit

@MainActor
final class CalendarViewModel: ObservableObject {
    @Published var todayEvents: [CalendarEvent] = []
    @Published var tomorrowEvents: [CalendarEvent] = []
    @Published var hasAccess: Bool = false
    @Published var isLoading: Bool = false

    private let service = CalendarService()

    var todaySection: EventSection {
        EventSection(title: "Today", events: todayEvents)
    }

    var tomorrowSection: EventSection {
        EventSection(title: "Tomorrow", events: tomorrowEvents)
    }

    func requestAccess() async {
        hasAccess = await service.requestAccess()
        if hasAccess { loadEvents() }
    }

    func loadEvents() {
        isLoading = true
        todayEvents = service.fetchTodayEvents()
        tomorrowEvents = service.fetchTomorrowEvents()
        isLoading = false
    }

    func checkAccess() {
        hasAccess = service.authorizationStatus == .authorized
    }
}
