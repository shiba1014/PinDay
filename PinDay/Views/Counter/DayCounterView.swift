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

            BackgroundView(style: event.backgroundStyle)

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
                let progress = Int(Date.calcProgress(from: start, to: date) * 100)
                HStack {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 3)
                        .frame(width: 50, height: 50)
                    Text("\(progress)%")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct DayCounterView_Previews: PreviewProvider {
    static var previews: some View {
        DayCounterView.mock
    }
}

struct BackgroundView: View {
    private static let radius: CGFloat = 24
    var style: NewEvent.BackgroundStyle

    var body: some View {
        Group {
            switch style {
            case .color(let color):
                Rectangle()
                    .fill(color)
            case .image(let image):
                image
                    .fitToAspectRatio(1)
            }
        }
        .overlay(
            LinearGradient(
                gradient: Gradient(
                    stops: [
                        .init(color: .clear, location: 0.2),
                        .init(color: Color.black.opacity(0.5), location: 1.0)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: Self.radius))
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView(style: .color(.gray))
    }
}
