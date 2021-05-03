//
//  EventCreateView.swift
//  PinDay
//
//  Created by shiba on 2021/04/13.
//

import SwiftUI

struct EventCreateView: View {

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var event: Event
    @Binding var eventCreateType: EventCreateType?

    @State private var showCountStyleSheet = false
    @State private var showCreateBackgroundSheet = false
    @State private var showDeleteAlert = false

    private let isEdit: Bool

    init(editEvent: Event? = nil, eventCreateType: Binding<EventCreateType?>) {
        self.event = editEvent ?? .init()
        self._eventCreateType = eventCreateType
        self.isEdit = (editEvent != nil)
    }
    
    var body: some View {

        NavigationView {
            VStack {

                List {
                    VStack {
                        EventBackgroundView(style: event.backgroundStyle, size: .small)
                            .aspectRatio(contentMode: .fit)
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
                                    CreateBackgroundView(event: event)
                                }
                            )
                            .padding(.bottom, 24)

                        TextField(
                            "Event Title",
                            text: $event.title
                        )
                        .multilineTextAlignment(.center)
                        .font(.title)
                        Text("\(event.title.count) / \(Event.maxTitleCount)")
                            .foregroundColor(event.title.count > Event.maxTitleCount ? .red : .secondary)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "calendar")
                        DatePicker(
                            "Date",
                            selection: .init(get: { event.pinnedDateType.date }, set: { event.update(pinnedDate: $0.beginning()) }),
                            displayedComponents: [.date]
                        )
                    }

                    event.pinnedDateType.style.map { style in

                        Button(action: {
                            showCountStyleSheet = true

                        }) {
                            HStack {
                                Image(systemName: "hourglass")
                                    .padding(.horizontal, 3)
                                Text("Count Style")
                                Spacer()
                                Text(style.description)
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.tertiaryLabel))
                            }
                        }
                        .sheet(isPresented: $showCountStyleSheet) {
                            SelectCountStyleListView(
                                style: .init(
                                    get: { style },
                                    set: { try? event.update(futureCountStyle: $0) }
                                )
                            )
                        }
                    }

                    event.pinnedDateType.startDate.map { startDate in
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            DatePicker(
                                "Start Date",
                                selection: .init(
                                    get: { startDate },
                                    set: { try? event.update(futureCountStyle: .progress(from: $0.beginning())) }
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
                                    PersistenceController.shared.delete(event)
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
                    NavigationLink(destination: EventPreviewView(event: event, eventCreateType: $eventCreateType)) {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!event.isValid)
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
