//
//  SelectCountStyleListView.swift
//  PinDay
//
//  Created by shiba on 2021/04/18.
//

import SwiftUI

struct SelectCountStyleListView: View {

    @Environment(\.presentationMode) var presentationMode

    @Binding var countStyle: CountStyle

    init(countStyle: Binding<CountStyle>) {
        self._countStyle = countStyle
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: EventViewSize.small.gridLayout(spacing: 0)) {
                    ForEach(
                        CountStyle.allCases,
                        id: \.self
                    ) { style in
                        VStack {
                            style.preview
                            Text(style.description)
                        }
                        .padding()
                        .onTapGesture {
                            if countStyle != style {
                                countStyle = style
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                        .background(self.countStyle == style ? Color(UIColor.tertiarySystemFill) : Color.clear)
                    }
                }
            }
            .navigationBarTitle("Count Style", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct SelectCountStyleListView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountStyleListView(countStyle: .constant(.countUp))
    }
}
