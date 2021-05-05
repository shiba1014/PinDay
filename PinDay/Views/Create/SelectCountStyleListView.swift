//
//  SelectCountStyleListView.swift
//  PinDay
//
//  Created by shiba on 2021/04/18.
//

import SwiftUI

struct SelectCountStyleListView: View {

    @Environment(\.presentationMode) var presentationMode

    typealias CountStyle = Event.PinnedDateType.FutureCountStyle
    @Binding var style: CountStyle

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach(CountStyle.allCases) { style in
                        optionBox(style)
                            .padding()
                            .aspectRatio(1, contentMode: .fit)
                            .onTapGesture {
                                self.style = style
                            }
                            .background(self.style == style ? Color(UIColor.tertiarySystemFill) : Color.clear)
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

    @ViewBuilder
    private func optionBox(_ style: CountStyle) -> some View {
        switch style {
        case .countDown:
            VStack {
                EventSummaryView(event: .countDownMock, size: .small)
                    .aspectRatio(1, contentMode: .fill)
                Text(style.description)
            }
        case .progress:
            VStack {
                EventSummaryView(event: .progressMock, size: .small)
                    .aspectRatio(1, contentMode: .fill)
                Text(style.description)
            }
        }
    }
}

struct SelectCountStyleListView_Previews: PreviewProvider {
    @State static var style: Event.PinnedDateType.FutureCountStyle = .countDown
    static var previews: some View {
        SelectCountStyleListView(style: $style)
    }
}

struct NewSelectCountStyleListView: View {

    enum CountStyle: String, CaseIterable {
        case countDown
        case progress

        var description: String {
            switch self {
            case .countDown: return "Count Down"
            case .progress: return "Progress"
            }
        }

        var preview: NewEventSummaryView {
            switch self {
            case .countDown: return .countDownMock(size: .small)
            case .progress: return .progressMock(size: .small)
            }
        }
    }

    @Environment(\.presentationMode) var presentationMode

    @Binding var startDate: Date?
    @State var selectedStyle: CountStyle = .countDown

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
