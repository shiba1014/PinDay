//
//  CreateView.swift
//  PinDay
//
//  Created by shiba on 2021/04/13.
//

import SwiftUI

class NewEvent: ObservableObject {

    enum CountStyle {
        case countUp
        case countDown
        case progress(from: Date)

        func isFutureStyle() -> Bool {
            switch self {
            case .countUp:
                return false
            case .countDown, .progress:
                return true
            }
        }

        static let futureDefault: Self = .countDown
        static let pastDefault: Self = .countUp
    }

    @Published var title: String = ""
    @Published var pinnedDate: Date = .init()
    @Published var countStyle: CountStyle = .countUp

    func updatePinnedDate(_ date: Date) {
        pinnedDate = date.beginning()
        if date.isFuture() && !countStyle.isFutureStyle() {
            countStyle = .futureDefault
        }
        else if !date.isFuture() && countStyle.isFutureStyle() {
            countStyle = .pastDefault
        }
    }
}

struct CreateView: View {

    private let calendar: Calendar = .init(identifier: .gregorian)

    @Environment(\.presentationMode) var presentationMode
    @State private var eventTitle: String = ""
    @State private var startDate: Date = .init()

    @ObservedObject private var newEvent: NewEvent = .init()

    private var pinnedDateProxy: Binding<Date> {
        .init(
            get: { newEvent.pinnedDate },
            set: { newEvent.updatePinnedDate($0) }
        )
    }
    
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
                            selection: pinnedDateProxy,
                            displayedComponents: [.date]
                        )
                    }

                    if calendar.startOfDay(for: newEvent.pinnedDate) > calendar.startOfDay(for: Date()) {
                        NavigationLink(
                            destination: SelectCountStyleListView()
                        ) {
                            HStack {
                                Image(systemName: "hourglass")
                                    .padding(.horizontal, 3)
                                Text("Count Style")
                                Spacer()
                                Text("Progress")
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    if case .progress = newEvent.countStyle {
                        HStack {
                            Image(systemName: "calendar.badge.plus")
                            DatePicker(
                                "Start Date",
                                selection: $startDate,
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
