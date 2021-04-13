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
    @State private var startDate: Date = .init()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Rectangle()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
                    .cornerRadius(5)
                    .padding(.horizontal, 50)
                TextField(
                    "Event Title",
                    text: $eventTitle
                )
                .multilineTextAlignment(.center)
                .font(.title)
                
                Divider()
                
                HStack {
                    Image(systemName: "calendar")
                    DatePicker(
                        "Date",
                        selection: $pinnedDate,
                        displayedComponents: [.date]
                    )
                }
                .padding(.horizontal)
                
                HStack {
                    Image(systemName: "calendar.badge.plus")
                    DatePicker(
                        "Start Date",
                        selection: $pinnedDate,
                        displayedComponents: [.date]
                    )
                }
                .padding(.horizontal)
                
                HStack {
                    Image(systemName: "hourglass")
                        .padding(.horizontal, 3)
                    Text("Count Style")
                    Spacer()
                    Text("Progress")
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Create", displayMode: .inline)
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
