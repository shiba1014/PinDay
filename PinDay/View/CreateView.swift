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
    @State private var description: String = ""
    @State private var pinnedDate: Date = .init()
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField(
                        "Event Title",
                        text: $eventTitle
                    )
                    TextField(
                        "Description",
                        text: $description
                    )
                }
                Section {
                    DatePicker(
                        "Date",
                        selection: $pinnedDate,
                        displayedComponents: [.date]
                    )
                }
            }
            .listStyle(InsetGroupedListStyle())
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
