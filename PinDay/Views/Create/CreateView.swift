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

    @ObservedObject private var newEvent: NewEvent = .init()
    
    var body: some View {

        NavigationView {
            VStack {

                List {
                    VStack(spacing: 24) {
                        Rectangle()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                            .cornerRadius(5)
                            .padding(.horizontal, 50)
                            .overlay(
                                    ZStack {
                                        Circle()
                                            .frame(width: 70)
                                            .foregroundColor(.secondary)
                                            .shadow(radius: 4)
                                        Image(systemName: "camera.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .onTapGesture {
                                        showCreateBackgroundSheet.toggle()
                                    }
                                    .sheet(isPresented: $showCreateBackgroundSheet) {
                                        CreateBackgroundView()
                                    }
                            )

                        TextField(
                            "Event Title",
                            text: $newEvent.title
                        )
                        .multilineTextAlignment(.center)
                        .font(.title)
                    }
                    .padding()
                    
                    HStack {
                        Image(systemName: "calendar")
                        DatePicker(
                            "Date",
                            selection: .init(get: { newEvent.pinnedDateType.date }, set: { newEvent.update(pinnedDate: $0) }),
                            displayedComponents: [.date]
                        )
                    }

                    newEvent.pinnedDateType.style.map { style in

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
                                    set: { try? newEvent.update(futureCountStyle: $0) }
                                )
                            )
                        }
                    }

                    newEvent.pinnedDateType.startDate.map { startDate in
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            DatePicker(
                                "Start Date",
                                selection: .init(
                                    get: { startDate },
                                    set: { try? newEvent.update(futureCountStyle: .progress(from: $0)) }
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
                    Button(action: {
                    }) {
                        Image(systemName: "chevron.forward")
                    }
                    .disabled(!newEvent.isValid)
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
