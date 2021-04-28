//
//  SelectCountStyleListView.swift
//  PinDay
//
//  Created by shiba on 2021/04/18.
//

import SwiftUI

struct SelectCountStyleListView: View {

    @Environment(\.presentationMode) var presentationMode

    typealias CountStyle = NewEvent.PinnedDateType.FutureCountStyle
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

    private func optionBox(_ style: CountStyle) -> some View {
        VStack {
            DayCounterView.mock
                .aspectRatio(1, contentMode: .fill)
            Text(style.description)
        }
    }
}

struct SelectCountStyleListView_Previews: PreviewProvider {
    @State static var style: NewEvent.PinnedDateType.FutureCountStyle = .countDown
    static var previews: some View {
        SelectCountStyleListView(style: $style)
    }
}

