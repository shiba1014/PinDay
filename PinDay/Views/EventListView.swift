//
//  EventListView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import SwiftUI

struct EventListView: View {
    
    @State private var showCreateView = false
    @State private var selectedEvent: Event? = nil

    private let gridItems = [GridItem(), GridItem()]
    private let events: [Event] = (0...6).map { i in
        if i%3 == 0 { return .pastMock }
        else if i%3 == 1 { return .countDownMock }
        else { return .progressMock }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems) {
                    ForEach(events.indices) { i in
                        Button(action: {
                            selectedEvent = events[i]
                        }) {
                            EventSummaryView(event: events[i], size: .small)
                                .aspectRatio(1, contentMode: .fill)
                        }
                    }
                }
                .fullScreenCover(item: $selectedEvent) { event in
                    EventDetailView(event: event)
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
                            showCreateView.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $showCreateView) {
                            CreateView()
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
