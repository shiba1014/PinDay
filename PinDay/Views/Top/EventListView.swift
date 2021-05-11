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
        entity: Event.entity(),
        sortDescriptors: [],
        animation: .default
    )
    private var events: FetchedResults<Event>

    @State private var eventCreateType: EventCreateType? = nil
    @State private var selectedEvent: Event? = nil
    @State private var showTipsView: Bool = false
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
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: userSettings.eventViewSize.gridLayout(spacing: Self.spacing), spacing: Self.spacing) {
                        ForEach(
                            events.sorted(by: { userSettings.sortOption.sort($0, $1) })
                        ) { event in
                            Button(action: {
                                selectedEvent = event
                            }) {
                                EventSummaryView(event: event, size: userSettings.eventViewSize)
                            }
                        }
                    }
                    .sheet(isPresented: $showTipsView, content: {
                        TipsView()
                    })
                    .padding()
                    .animation(.spring())
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            Menu {
                                Section {
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
                                }
                                Section {
                                    Button(action: {
                                        showTipsView = true
                                    }) {
                                        Image(systemName: "pin.fill")
                                        Text("Tips")
                                    }
                                }
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                            }
                        }

                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                // Create EventDraft instance here
                                // to prevent re-init create view when updating list view.
                                eventCreateType = .new(draft: .init())
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            .sheet(item: $eventCreateType) { type in
                switch type {
                case .new(let draft):
                    EventCreateView(draft: draft, eventCreateType: $eventCreateType)
                case .edit(let event):
                    EventCreateView(draft: event.createDraft(), eventCreateType: $eventCreateType)
                }
            }
            .onOpenURL { url in
                guard let uuidStr = url.queryValue(for: "id") ,
                      let event = PersistenceController.shared.fetchEvent(uuidStr) else { return }
                selectedEvent = event
            }

            if events.isEmpty {
                VStack(alignment: .center, spacing: 16) {
                    Image("Logo")
                        .resizable()
                        .frame(width: 100, height: 100)

                    Text("There is no event.")

                    Text("Let's pin your important day.")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
        }
    }
}

extension URL {
    func queryValue(for key: String) -> String? {
        let queryItems = URLComponents(string: absoluteString)?.queryItems
        return queryItems?.filter { $0.name == key }.compactMap { $0.value }.first
    }
}

struct EventListView_Previews: PreviewProvider {
    static var previews: some View {
        EventListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
