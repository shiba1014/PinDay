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
    @Binding var eventCreateType: EventCreateType?

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
            EventSummaryView(event: event, size: .fullscreen)
                .ignoresSafeArea()

            buildToolBar()
                .padding(8)
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
                eventCreateType = .edit(event: event)
                presentationMode.wrappedValue.dismiss()
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

            event.makeCounterView(size: .fullscreen)
        }
    }
}

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(event: .countDownMock, eventCreateType: .constant(nil))
    }
}
