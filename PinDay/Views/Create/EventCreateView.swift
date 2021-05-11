//
//  EventCreateView.swift
//  PinDay
//
//  Created by shiba on 2021/04/13.
//

import SwiftUI

struct EventCreateView: View, Equatable {

    // Ref: https://www.hackingwithswift.com/forums/swiftui/how-can-i-make-my-view-stop-unnecessary-rendering-with-using-customtype-for-binding-in-swiftui/6900
    static func == (lhs: EventCreateView, rhs: EventCreateView) -> Bool {
        lhs.draft.id == rhs.draft.id
    }

    @ObservedObject var draft: EventDraft
    @Binding var eventCreateType: EventCreateType?

    @State private var showCountStyleSheet = false
    @State private var showCreateBackgroundSheet = false
    @State private var showDeleteAlert = false

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
                                set: { draft.pinnedDate = Calendar.gregorian.startOfDay(for: $0) }
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
                                    set: { self.draft.startDate = Calendar.gregorian.startOfDay(for: $0) }
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
            .navigationBarTitle(eventCreateType?.title ?? "", displayMode: .inline)
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
        EventCreateView(draft: .init(), eventCreateType: .constant(.new(draft: .init())))
    }
}
