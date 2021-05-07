//
//  EventListView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import SwiftUI

struct EventListView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @State private var eventCreateType: EventCreateType? = nil
    @State private var selectedEvent: Event? = nil

    @ObservedObject var userSettings: UserSettings = .init()

    private static let spacing: CGFloat = 16

    // Ref: https://www.hackingwithswift.com/forums/swiftui/using-sheet-and-fullscreencover-together/4258
    var body: some View {
        ZStack {
            EmptyView()
                .fullScreenCover(item: $selectedEvent) { event in
                    EventDetailView(event: event, eventCreateType: $eventCreateType)
                }

            NavigationView {
                ScrollView {
                    LazyVGrid(columns: userSettings.eventViewSize.gridLayout(spacing: Self.spacing), spacing: Self.spacing) {
                        FilteredEventList(sortOption: userSettings.sortOption) { event in
                            Button(action: {
                                selectedEvent = event
                            }) {
                                EventSummaryView(event: event, size: userSettings.eventViewSize)
                            }
                        }
                    }
                    .padding()
                    .animation(.spring())
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Menu {
                                Menu("Event Size") {
                                    Picker(
                                        "Event Size",
                                        selection: $userSettings.eventViewSize
                                    ) {
                                        ForEach([EventViewSize.small, EventViewSize.medium], id: \.self) { size in
                                            Text(size.description)
                                        }
                                    }
                                }

                                Menu("Sort By") {
                                    Picker(
                                        "Sort Options",
                                        selection: $userSettings.sortOption
                                    ) {
                                        ForEach(SortOption.allCases, id: \.self) { option in
                                            Text(option.description)
                                        }
                                    }
                                }
                            } label: {
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
