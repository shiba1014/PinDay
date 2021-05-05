//
//  EventPreviewView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct EventPreviewView: View {

    let draft: EventDraft
    @State private var previewSize: EventViewSize = .small

    var body: some View {

        VStack {
            Picker(
                "Preview Size",
                selection: $previewSize
            ) {
                ForEach(EventViewSize.allCases, id: \.self) { size in
                    Text(size.description)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            EventSummaryView(draft: draft, size: previewSize)
                .padding(.horizontal, previewSize == .small ? 100 : 0)
                .padding(.top)
                .animation(.spring())

            Spacer()
        }
        .padding()
        .navigationBarTitle("Preview", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {

                }
            }
        }
    }
}
