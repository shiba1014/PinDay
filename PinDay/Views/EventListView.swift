//
//  EventListView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import SwiftUI

struct EventListView: View {

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: EventEntity.entity(),
        sortDescriptors: [.init(keyPath: \EventEntity.createdAt, ascending: true)],
        animation: .default
    )
    private var entities: FetchedResults<EventEntity>

    @State private var eventCreateType: EventCreateType? = nil
    @State private var selectedEvent: Event? = nil

    private static let spacing: CGFloat = 16
    private let gridItems = [GridItem(spacing: Self.spacing), GridItem(spacing: Self.spacing)]

    var body: some View {
        ZStack {
            EmptyView()
                .fullScreenCover(item: $selectedEvent) { event in
                    EventDetailView(event: event, eventCreateType: $eventCreateType)
                }

            NavigationView {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: Self.spacing) {
                        ForEach(entities.compactMap { try? Event(data: $0) }, id: \Event.id) { event in
                            Button(action: {
                                selectedEvent = event
                            }) {
                                EventSummaryView(event: event, size: .small)
                                    .aspectRatio(1, contentMode: .fill)
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
                        }
                    }
                }
            }
            .sheet(item: $eventCreateType) { type in
                EventCreateView(eventCreateType: $eventCreateType)
            }
        }
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
