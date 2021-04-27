//
//  DayCounterView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/11.
//

import SwiftUI

struct DayCounterView: View {

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            BackgroundView(style: .constant(.color(.gray)))

            VStack(alignment: .leading, spacing: 8) {
                Text("Xmas")
                    .font(Font.title2.weight(.medium))
                Text("37 days left")
                    .font(.body)
            }
            .padding(.all, 20)

        }
    }
}

struct DayCounterView_Previews: PreviewProvider {
    static var previews: some View {
        DayCounterView()
    }
}

