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
                selection:
                    .init(
                        get: { previewSize },
                        set: { size in
                            withAnimation {
                                previewSize = size
                            }

                        }
                    )
            ) {
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

                    switch eventCreateType {
                    case .new:
                        PersistenceController.shared.save(event)
                    case .edit:
                        break
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
