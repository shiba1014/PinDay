//
//  EventPreviewView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct EventPreviewView: View {

    private enum PreviewSize: String, CaseIterable {
        case small = "Small"
        case medium = "Medium"
        case fullscreen = "Full Screen"
    }

    @ObservedObject var event: Event
    @State private var previewSize: PreviewSize = .medium

    var body: some View {
        NavigationView {
            VStack {
                Picker("Preview Size", selection: $previewSize) {
                    ForEach(PreviewSize.allCases, id: \.self) { size in
                        Text(size.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                buildPreview()
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

    @ViewBuilder
    private func buildPreview() -> some View {
        switch previewSize {
        case .small:
            EventSummaryView(event: event)
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 100)

        case .medium:
            EventSummaryView(event: event)
                .aspectRatio(1.77, contentMode: .fit)

        case .fullscreen:
            EventSummaryView(event: event)
        }
    }
}

struct EventPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        EventPreviewView(event: .countDownMock)
    }
}
