//
//  SelectCountStyleListView.swift
//  PinDay
//
//  Created by shiba on 2021/04/18.
//

import SwiftUI

struct SelectCountStyleListView: View {

    enum CountStyle: String, CaseIterable {
        case countDown
        case progress

        var description: String {
            switch self {
            case .countDown: return "Count Down"
            case .progress: return "Progress"
            }
        }

        var preview: EventSummaryView {
            switch self {
            case .countDown: return EventSummaryView(draft: .countdownMock, size: .small)
            case .progress: return EventSummaryView(draft: .progressMock, size: .small)
            }
        }
    }

    @Environment(\.presentationMode) var presentationMode

    @Binding var startDate: Date?
    @State private var selectedStyle: CountStyle

    init(startDate: Binding<Date?>) {
        self._startDate = startDate
        self._selectedStyle = State<CountStyle>(
            initialValue: (startDate.wrappedValue == nil)
                ? .countDown
                : .progress
        )
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach(CountStyle.allCases, id: \.self) { style in
                        VStack {
                            style.preview
                            Text(style.description)
                        }
                            .padding()
                            .onTapGesture {
                                self.selectedStyle = style
                                switch style {
                                case .countDown:
                                    self.startDate = nil
                                case .progress:
                                    self.startDate = Date()
                                }
                            }
                            .background(self.selectedStyle == style ? Color(UIColor.tertiarySystemFill) : Color.clear)
                    }
                }

                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct SelectCountStyleListView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountStyleListView(startDate: .constant(nil))
    }
}
