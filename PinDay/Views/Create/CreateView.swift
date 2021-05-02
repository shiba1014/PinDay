//
//  CreateView.swift
//  PinDay
//
//  Created by shiba on 2021/04/13.
//

import SwiftUI

struct CreateView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var eventTitle: String = ""
    @State private var startDate: Date = .init()

    @State private var showCountStyleSheet = false
    @State private var showCreateBackgroundSheet = false

    @ObservedObject private var event: Event

    init(editEvent: Event? = nil) {
        self.event = editEvent ?? .init()
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
                                        showCreateBackgroundSheet.toggle()
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
                            selection: .init(get: { event.pinnedDateType.date }, set: { event.update(pinnedDate: $0) }),
                            displayedComponents: [.date]
                        )
                    }

                    event.pinnedDateType.style.map { style in

                        Button(action: { showCountStyleSheet.toggle() }) {
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
                                    set: { try? event.update(futureCountStyle: .progress(from: $0)) }
                                ),
                                in: ...Date(),
                                displayedComponents: [.date]
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
                    NavigationLink(destination: EventPreviewView(event: event)) {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!event.isValid)
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
