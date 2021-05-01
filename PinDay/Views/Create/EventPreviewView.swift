//
//  EventPreviewView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct EventPreviewView: View {

    @ObservedObject var event: Event
    @State private var previewSize: EventViewSize = .fullscreen

    var body: some View {

        VStack {
            Picker("Preview Size", selection: $previewSize) {
                ForEach(EventViewSize.allCases, id: \.self) { size in
                    Text(size.description)
                }
            }
            .pickerStyle(SegmentedPickerStyle())

            EventSummaryView(event: event, size: previewSize)
                .if(previewSize == .small) {
                    $0.padding(.horizontal, 100)
                }
                .padding(.top)

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

struct EventPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        EventPreviewView(event: .countDownMock)
    }
}
