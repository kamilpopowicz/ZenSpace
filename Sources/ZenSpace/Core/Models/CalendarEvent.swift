import Foundation

struct CalendarEvent: Codable, Identifiable {
    let id: String
    let title: String
    let location: String?
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
    let calendarColor: String?
    let isTomorrow: Bool
    let isPast: Bool
    let isUpcoming: Bool
}

struct EventSection: Identifiable {
    var id: String { title }
    let title: String
    let events: [CalendarEvent]
    var isEmpty: Bool { events.isEmpty }
}

enum TransportMode: String, Codable, CaseIterable {
    case driving
    case transit
    case walking
}
