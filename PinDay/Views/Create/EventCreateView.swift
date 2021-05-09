//
//  EventCreateView.swift
//  PinDay
//
//  Created by shiba on 2021/04/13.
//

import SwiftUI

struct EventCreateView: View {

    @ObservedObject private var draft: EventDraft
    @Binding var eventCreateType: EventCreateType?

    @State private var showCountStyleSheet = false
    @State private var showCreateBackgroundSheet = false
    @State private var showDeleteAlert = false

    init(editEvent: Event? = nil, eventCreateType: Binding<EventCreateType?>) {
        if let editEvent = editEvent {
            self.draft = editEvent.createDraft()
        }
        else {
            self.draft = .init()
        }
        self._eventCreateType = eventCreateType
    }

    var body: some View {

        NavigationView {
            VStack {

                List {
                    VStack {
                        EventBackgroundView(draft: draft, size: .small)
                            .padding(.horizontal, 50)
                            .overlay(
                                ZStack {
                                    Circle()
                                        .frame(width: 70)
                                        .foregroundColor(.init(white: 0.9))
                                        .shadow(radius: 4)
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(Color(.appBlack))
                                }
                                .onTapGesture {
                                    showCreateBackgroundSheet = true
                                }
                                .sheet(isPresented: $showCreateBackgroundSheet) {
                                    CreateBackgroundView(draft: draft)
                                }
                            )
                            .padding(.bottom, 24)

                        TextField(
                            "Event Title",
                            text: $draft.title
                        )
                        .multilineTextAlignment(.center)
                        .font(.title)
                        Text("\(draft.title.count) / \(EventDraft.maxTitleCount)")
                            .foregroundColor(draft.title.count > EventDraft.maxTitleCount ? Color(.appRed) : .secondary)
                    }
                    .padding()

                    HStack {
                        Image(systemName: "calendar")
                        DatePicker(
                            "Pinned Date",
                            selection: .init(
                                get: { draft.pinnedDate },
                                set: { draft.pinnedDate = $0.beginning() }
                            ),
                            displayedComponents: [.date]
                        )
                    }

                    if draft.pinnedDate.isFuture() {

                        Button(action: {
                            showCountStyleSheet = true
                        }) {
                            HStack {
                                Image(systemName: "hourglass")
                                    .padding(.horizontal, 3)
                                Text("Count Style")
                                Spacer()
                                Text(
                                    draft.startDate != nil
                                        ? SelectCountStyleListView.CountStyle.progress.description
                                        : SelectCountStyleListView.CountStyle.countDown.description
                                )
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.tertiaryLabel))
                            }
                        }
                        .sheet(isPresented: $showCountStyleSheet) {
                            SelectCountStyleListView(startDate: $draft.startDate)
                        }
                    }

                    draft.startDate.map { startDate in
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            DatePicker(
                                "Start Date",
                                selection: .init(
                                    get: { startDate },
                                    set: { self.draft.startDate = $0.beginning() }
                                ),
                                in: ...Date(),
                                displayedComponents: [.date]
                            )
                        }
                    }

                    eventCreateType.map { type in
                        Group {
                            if case .edit(let event) = type {
                                Spacer()
                                Button(action: {
                                    showDeleteAlert = true
                                }) {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "trash")
                                        Text("Delete This Event")
                                        Spacer()
                                    }
                                    .foregroundColor(Color(.appRed))
                                }
                                .alert(isPresented: $showDeleteAlert) {
                                    Alert(
                                        title: Text("Delete Event"),
                                        message: Text("Are you sure you want to delete this event?"),
                                        primaryButton: .cancel(),
                                        secondaryButton: .destructive(Text("Delete")) {
                                            eventCreateType = nil
                                            PersistenceController.shared.delete(event)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        eventCreateType = nil
                    }) {
                        Image(systemName: "xmark")
                    }
                }


                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(
                        destination: EventPreviewView(draft: draft, eventCreateType: $eventCreateType)
                    ) {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!draft.isValid)
                }
            }
        }
    }
}

struct EventCreateView_Previews: PreviewProvider {
    static var previews: some View {
        EventCreateView(eventCreateType: .constant(.new))
    }
}
