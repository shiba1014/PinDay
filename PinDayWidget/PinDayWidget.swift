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
        let event = events.first { $0.id.uuidString == configuration.event?.identifier } ?? nil
        var currentDate = Date()
        for hourOffset in 0 ..< 3 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = EventEntry(date: entryDate, event: event)
            entries.append(entry)
            if hourOffset == 0 {
                currentDate = currentDate.fixed(minute:0, second: 0)
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct EventEntry: TimelineEntry {
    let date: Date
    let event: Event?
}

extension Event {
    static let snapshot: Event = {
        let event = Event.init(entity: Event.entity(), insertInto: nil)
        let date = Date().fixed(month: 1, day: 1).added(year: 1).beginning()
        event.id = UUID()
        event.title = "\(date.year)"
        event.pinnedDate = date
        event.backgroundColor = Data.encode(color: .appRed)
        event.createdAt = Date()
        return event
    }()
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
