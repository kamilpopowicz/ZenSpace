import EventKit
import Foundation

final class CalendarService {
    private let store = EKEventStore()

    var authorizationStatus: EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: .event)
    }

    func requestAccess() async -> Bool {
        if #available(macOS 14.0, *) {
            return (try? await store.requestFullAccessToEvents()) ?? false
        } else {
            return await withCheckedContinuation { continuation in
                store.requestAccess(to: .event) { granted, _ in
                    continuation.resume(returning: granted)
                }
            }
        }
    }

    func fetchTodayEvents() -> [CalendarEvent] {
        fetchEvents(for: Date(), isTomorrow: false)
    }

    func fetchTomorrowEvents() -> [CalendarEvent] {
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { return [] }
        return fetchEvents(for: tomorrow, isTomorrow: true)
    }

    private func fetchEvents(for date: Date, isTomorrow: Bool) -> [CalendarEvent] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return [] }

        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
        let now = Date()

        return store.events(matching: predicate).map { event in
            CalendarEvent(
                id: event.eventIdentifier,
                title: event.title,
                location: event.location,
                startDate: event.startDate,
                endDate: event.endDate,
                isAllDay: event.isAllDay,
                calendarColor: event.calendar.cgColor.flatMap { colorHex($0) },
                isTomorrow: isTomorrow,
                isPast: event.endDate < now,
                isUpcoming: event.startDate > now
            )
        }
    }

    private func colorHex(_ cgColor: CGColor) -> String? {
        guard let components = cgColor.components, components.count >= 3 else { return nil }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
