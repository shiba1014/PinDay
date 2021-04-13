//
//  DayCounterView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/11.
//

import SwiftUI

struct DayCounterView: View {

    var body: some View {
        GeometryReader { geometory in
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

                Rectangle()
                    .fill(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                VStack(alignment: .leading, spacing: 16) {
                    Text("Xmas")
                        .font(.title)
                    Text("37 days left")
                        .font(.body)
                }
                .padding(.all, 20)

            }
        }
    }
}
