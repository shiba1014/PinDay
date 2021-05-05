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

    // Receive editEvent because eventCreateType is not correct value at first time.
    init(editEvent: Event? = nil, eventCreateType: Binding<EventCreateType?>) {

        self._eventCreateType = eventCreateType

        if let editEvent = editEvent {
            self.event = Event.copy(editEvent)
            self.isEdit = true
        } else {
            self.event = .init()
            self.isEdit = false
        }
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
                    NavigationLink(
                        destination: EventPreviewView(event: event, eventCreateType: $eventCreateType)
                    ) {
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

class EventDraft: ObservableObject {

    enum BackgroundStyle {
        case color(UIColor)
        case image(UIImage)

        var color: Color? {
            switch self {
            case .color(let color): return Color(color)
            case .image: return nil
            }
        }

        var image: Image? {
            switch self {
            case .color: return nil
            case .image(let image): return Image(uiImage: image)
            }
        }
    }

    static let maxTitleCount: Int = 15

    @Published var title: String
    @Published var pinnedDate: Date
    @Published var startDate: Date?
    @Published var backgroundStyle: BackgroundStyle

    var color: Color? {
        switch backgroundStyle {
        case .color(let color): return Color(color)
        case .image: return nil
        }
    }

    var image: Image? {
        switch backgroundStyle {
        case .color: return nil
        case .image(let image): return Image(uiImage: image)
        }
    }

    var isValid: Bool {
        !title.isEmpty && title.count <= Self.maxTitleCount
    }

    init(
        title: String = "",
        pinnedDate: Date = .init(),
        startDate: Date? = nil,
        backgroundStyle: BackgroundStyle = .color(.gray)
    ) {
        self.title = title
        self.pinnedDate = pinnedDate
        self.startDate = startDate
        self.backgroundStyle = backgroundStyle
    }
}

struct NewEventCreateView: View {

    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var draft: EventDraft = .init()

    @State private var showCountStyleSheet = false
    @State private var showCreateBackgroundSheet = false
    @State private var showDeleteAlert = false

    init(editEvent: EventEntity? = nil) {
        if let editEvent = editEvent {
            draft.title = editEvent.title
            draft.pinnedDate = editEvent.pinnedDate
            draft.startDate = editEvent.startDate
        }
    }

    var body: some View {

        NavigationView {
            VStack {

                List {
                    VStack {
                        NewBackgroundView(draft: draft, size: .small)
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
                                    NewCreateBackgroundView(draft: draft)
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
                            NewSelectCountStyleListView(startDate: $draft.startDate)
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

//
//                    if isEdit {
//                        Spacer()
//                        Button(action: {
//                            showDeleteAlert = true
//                        }) {
//                            HStack {
//                                Spacer()
//                                Image(systemName: "trash")
//                                Text("Delete This Event")
//                                Spacer()
//                            }
//                            .foregroundColor(.red)
//                        }
//                        .alert(isPresented: $showDeleteAlert) {
//                            Alert(
//                                title: Text("Delete Event"),
//                                message: Text("Are you sure you want to delete this event?"),
//                                primaryButton: .cancel(),
//                                secondaryButton: .destructive(Text("Delete")) {
//                                    PersistenceController.shared.delete(event)
//                                    presentationMode.wrappedValue.dismiss()
//                                }
//                            )
//                        }
//                    }
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
                        destination: NewEventPreviewView(draft: draft)
                    ) {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!draft.isValid)
                }
            }
        }
    }
}
