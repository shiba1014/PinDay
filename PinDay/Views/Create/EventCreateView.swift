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
    @State private var countStyle: CountStyle

    @State private var showCountStyleSheet = false
    @State private var showCreateBackgroundSheet = false
    @State private var showDeleteAlert = false

    init (draft: EventDraft, eventCreateType: Binding<EventCreateType?>) {
        self.draft = draft
        self._eventCreateType = eventCreateType
        self.countStyle = draft.countStyle
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

                    Button(action: {
                        showCountStyleSheet = true
                    }) {
                        HStack {
                            Image(systemName: "hourglass")
                                .padding(.horizontal, 3)
                            Text("Count Style")
                            Spacer()
                            Text(countStyle.description)
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                        }
                    }
                    .sheet(isPresented: $showCountStyleSheet) {
                        SelectCountStyleListView(
                            countStyle: .init(
                                get: { countStyle },
                                set: { style in
                                    countStyle = style
                                    draft.update(style)
                                }
                            )
                        )
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
                                in: ...Calendar.gregorian.move(day: -1, from: draft.pinnedDate),
                                displayedComponents: [.date]
                            )
                        }
                    }
                    
                    HStack {
                        Image(systemName: "calendar")
                        buildPinnedDatePicker()
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

    func buildPinnedDatePicker() -> DatePicker<Text> {

        let title = "Pinned Date"
        let selection: Binding<Date> = .init(
            get: { draft.pinnedDate },
            set: { draft.pinnedDate = Calendar.gregorian.startOfDay(for: $0) }
        )
        let comps: DatePicker.Components = [.date]

        switch countStyle {
        case .countUp:
            return DatePicker(
                title,
                selection: selection,
                in: ...Date(),
                displayedComponents: comps
            )

        case .countDown, .progress:
            return DatePicker(
                title,
                selection: selection,
                in: Calendar.gregorian.move(day: 1, from: Date())...,
                displayedComponents: comps
            )
        }
    }
}

struct EventCreateView_Previews: PreviewProvider {
    static var previews: some View {
        EventCreateView(draft: .init(), eventCreateType: .constant(.new(draft: .init())))
    }
}

extension EventDraft {
    var countStyle: CountStyle {
        if pinnedDate < Date() {
            return .countUp
        }
        else {
            return startDate == nil ? .countDown : .progress
        }
    }

    func update(_ countStyle: CountStyle) {
        switch countStyle {
        case .countUp:
            pinnedDate = Calendar.gregorian.startOfDay(for: Date())
            startDate = nil

        case .countDown:
            let nextWeek = Calendar.gregorian.move(day: 7, from: Date())
            pinnedDate = Calendar.gregorian.startOfDay(for: nextWeek)
            startDate = nil

        case .progress:
            let nextWeek = Calendar.gregorian.move(day: 7, from: Date())
            pinnedDate = Calendar.gregorian.startOfDay(for: nextWeek)
            startDate = Calendar.gregorian.startOfDay(for: Date())
        }
    }
}
