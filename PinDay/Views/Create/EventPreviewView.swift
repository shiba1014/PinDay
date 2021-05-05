//
//  EventPreviewView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct EventPreviewView: View {

    @ObservedObject var event: Event
    @Binding var eventCreateType: EventCreateType?
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

            EventSummaryView(event: event, size: previewSize)
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

                    switch eventCreateType {
                    case .new:
                        PersistenceController.shared.create(event)
                    case .edit:
                        PersistenceController.shared.update(event)
                    case .none:
                        break
                    }

                    eventCreateType = nil
                }
            }
        }
    }
}

struct EventPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        EventPreviewView(event: .countDownMock, eventCreateType: .constant(nil))
    }
}

struct NewEventPreviewView: View {

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

            NewEventSummaryView(draft: draft, size: previewSize)
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
