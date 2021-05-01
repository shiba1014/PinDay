//
//  DayCounterView.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/11.
//

import SwiftUI

struct DayCounterView: View {
    private static let radius: CGFloat = 24

    @ObservedObject var event: NewEvent

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            CounterBackgroundView(style: event.backgroundStyle)

            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(Font.title2.weight(.medium))
                    .foregroundColor(.white)

                makeContent()
            }
            .padding(.all, 20)

        }
    }

    static let mock: DayCounterView = {
        DayCounterView(event: .progressMock)
    }()

    @ViewBuilder
    private func makeContent() -> some View {

        switch event.pinnedDateType {

        case .past(let date):
            Text("\(date.calcDayDiff()) days ago")
                .font(.body)
                .foregroundColor(.white)

        case .future(let date, let style):
            switch style {

            case .countDown:
                Text("\(date.calcDayDiff()) days left")
                    .font(.body)
                    .foregroundColor(.white)

            case .progress(let start):
                CircularDayProgressView(start: start, end: date)
            }
        }
    }
}

struct DayCounterView_Previews: PreviewProvider {
    static var previews: some View {
        DayCounterView.mock
    }
}
