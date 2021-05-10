//
//  PinDayWidget.swift
//  PinDayWidget
//
//  Created by shiba on 2021/05/07.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {

    typealias Entry = EventEntry
    typealias Intent = SelectEventIntent

    func placeholder(in context: Context) -> EventEntry {
        EventEntry(date: Date(), event: nil)
    }

    func getSnapshot(for configuration: SelectEventIntent, in context: Context, completion: @escaping (EventEntry) -> ()) {
        let entry = EventEntry(date: Date(), event: .snapshot)
        completion(entry)
    }

    func getTimeline(for configuration: SelectEventIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let events = (try? PersistenceController.shared.fetchAllEvents()) ??  []
        var entries: [EventEntry] = []
        let event = events.first { $0.id.uuidString == configuration.event?.identifier }?.toWidgetEvent()
        var currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.gregorian.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = EventEntry(date: entryDate, event: event)
            entries.append(entry)
            if hourOffset == 0 {
                currentDate = Calendar.gregorian.oclock(of: currentDate)
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct EventEntry: TimelineEntry {
    let date: Date
    let event: WidgetEvent?
}

@main
struct PinDayWidget: Widget {
    let kind: String = "PinDayWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectEventIntent.self, provider: Provider()) { entry in
            PinDayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Event")
        .description("Count down or count up to your event.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct PinDayWidget_Previews: PreviewProvider {
    static var previews: some View {
        PinDayWidgetEntryView(entry: .init(date: Date(), event: .snapshot))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct WidgetEvent {
    var id: UUID
    var title: String
    var pinnedDate: Date
    var startDate: Date?
    var color: Color?
    var image: Image?

    static let snapshot: WidgetEvent = {
        let date = Calendar.gregorian.startOfDay(for: Calendar.gregorian.endOfYear(for: Date()))
        return WidgetEvent(
            id: UUID(),
            title: "\(Calendar.gregorian.year(of: date))",
            pinnedDate: date,
            startDate: nil,
            color: Color(.appRed),
            image: nil
        )
    }()
}

extension Event {
    func toWidgetEvent() -> WidgetEvent {
        WidgetEvent(id: id, title: title, pinnedDate: pinnedDate, startDate: startDate, color: color, image: image)
    }
}
