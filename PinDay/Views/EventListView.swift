//
//  EventListView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import SwiftUI

struct EventListView: View {

    @State private var eventCreateType: EventCreateType? = nil
    @State private var selectedEvent: Event? = nil

    private static let spacing: CGFloat = 16
    private let gridItems = [GridItem(spacing: Self.spacing), GridItem(spacing: Self.spacing)]
    private let events: [Event] = (0...6).map { i in
        if i%3 == 0 { return .pastMock }
        else if i%3 == 1 { return .countDownMock }
        else { return .progressMock }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: Self.spacing) {
                    ForEach(events.indices) { i in
                        Button(action: {
                            selectedEvent = events[i]
                        }) {
                            EventSummaryView(event: events[i], size: .small)
                                .aspectRatio(1, contentMode: .fill)
                        }
                        .fullScreenCover(item: $selectedEvent) { event in
                            EventDetailView(event: event, eventCreateType: $eventCreateType)
                        }
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            eventCreateType = .new
                        }) {
                            Image(systemName: "plus")
                        }
                        .sheet(item: $eventCreateType) { type in
                            switch type {
                            case .new:
                                CreateView(eventCreateType: $eventCreateType)
                            case .edit(let event):
                                CreateView(editEvent: event, eventCreateType: $eventCreateType)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
    }
}
