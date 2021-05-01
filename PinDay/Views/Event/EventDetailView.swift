//
//  EventDetailView.swift
//  PinDay
//
//  Created by shiba on 2021/05/01.
//

import SwiftUI

struct EventDetailView: View {

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var event: Event

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {

            CounterBackgroundView(style: event.backgroundStyle)
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                buildToolBar()
                Spacer()
                buildContent()
            }
            .padding(.all, 20)
        }
    }

    private func buildToolBar() -> some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(12)
                    .frame(width: 44, height: 44)
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: {
                // TODO: action sheet (edit/delete)
            }) {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(12)
                    .frame(width: 44, height: 44)
                    .foregroundColor(.white)
            }
        }
    }

    private func buildContent() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.title)
                .font(Font.title2.weight(.medium))
                .foregroundColor(.white)

            event.makeCounterView()
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: .countDownMock)
    }
}
