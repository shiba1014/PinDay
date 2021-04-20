//
//  SelectCountStyleListView.swift
//  PinDay
//
//  Created by shiba on 2021/04/18.
//

import SwiftUI

struct SelectCountStyleListView: View {

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(spacing: 20), GridItem(spacing: 20)]
            ) {
                optionBox(text: "Count down")
                optionBox(text: "Progress")
            }
            .padding()
        }.navigationBarTitle("Count Style", displayMode: .inline)
    }

    private func header(_ text: String) -> some View {
        HStack(alignment: .top, spacing: nil) {
            Text(text).font(.headline)
            Spacer()
        }
    }

    private func optionBox(text: String) -> some View {
        VStack {
            DayCounterView()
                .aspectRatio(1, contentMode: .fill)
            Text(text)
        }

    }
}

struct SelectCountStyleListView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCountStyleListView()
    }
}

