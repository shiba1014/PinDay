//
//  EventCreateView.swift
//  PinDay
//
//  Created by shiba on 2021/04/13.
//

import SwiftUI

struct EventCreateView: View {

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var draft: EventDraft
    @Binding var eventCreateType: EventCreateType?

    @State private var showCountStyleSheet = false
    @State private var showCreateBackgroundSheet = false
    @State private var showDeleteAlert = false

    private let isEdit: Bool

    init(editEvent: EventEntity? = nil, eventCreateType: Binding<EventCreateType?>) {
        if let editEvent = editEvent {
            self.draft = editEvent.createDraft()
            self.isEdit = true
        }
        else {
            self.draft = .init()
            self.isEdit = false
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
                                        .foregroundColor(.black)
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
                            .foregroundColor(draft.title.count > EventDraft.maxTitleCount ? .red : .secondary)
                    }
                    .padding()

                    HStack {
                        Image(systemName: "calendar")
                        DatePicker(
                            "Date",
                            selection: $draft.pinnedDate,
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
                                Text(draft.startDate != nil ? "Progress" : "Count Down")
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
                                    set: { self.draft.startDate = $0 }
                                ),
                                in: ...Date(),
                                displayedComponents: [.date]
                            )
                        }
                    }

                    if isEdit {
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
                            .foregroundColor(.red)
                        }
                        .alert(isPresented: $showDeleteAlert) {
                            Alert(
                                title: Text("Delete Event"),
                                message: Text("Are you sure you want to delete this event?"),
                                primaryButton: .cancel(),
                                secondaryButton: .destructive(Text("Delete")) {
//                                    PersistenceController.shared.delete(event)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            )
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }


                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(
                        destination: EventPreviewView(draft: draft)
                    ) {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!draft.isValid)
                }
            }
        }
    }
}
