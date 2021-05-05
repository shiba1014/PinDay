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
    @State private var selectedEntity: EventEntity? = nil
    @State private var eventViewSize: EventViewSize = .small

    private static let spacing: CGFloat = 16

    // Ref: https://www.hackingwithswift.com/forums/swiftui/using-sheet-and-fullscreencover-together/4258
    var body: some View {
        ZStack {
            EmptyView()
                .fullScreenCover(item: $selectedEntity) { entity in
                    EventDetailView(entity: entity, eventCreateType: $eventCreateType)
                }

            NavigationView {
                ScrollView {
                    LazyVGrid(columns: eventViewSize.gridLayout(spacing: Self.spacing), spacing: Self.spacing) {
                        ForEach(entities.indices) { i in
                            Button(action: {
                                selectedEntity = entities[i]
                            }) {
                                EventSummaryView(entity: entities[i], size: eventViewSize)
                            }
                        }
                    }
                    .padding()
                    .animation(.spring())
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Button(action: {
                                eventViewSize = eventViewSize != .small ? .small : .medium
                            }) {
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
                switch type {
                case .new:
                    EventCreateView(eventCreateType: $eventCreateType)
                case .edit(let event):
                    EventCreateView(editEvent: event, eventCreateType: $eventCreateType)
                }
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
