//
//  PersistenceController+Ext.swift
//  PinDay
//
//  Created by shiba on 2021/05/07.
//

import CoreData

extension PersistenceController {
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        for i in 0..<10 {
            let event = Event(context: viewContext)
            event.id = UUID()
            event.createdAt = Date()

            let draft: EventDraft
            if i%3 == 0 {
                draft = .pastMock
            }
            else if i%3 == 1 {
                draft = .countdownMock
            }
            else {
                draft = .progressMock
            }
            event.override(with: draft)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    func create(from draft: EventDraft) {

        let event = Event(context: container.viewContext)
        event.id = UUID()
        event.createdAt = Date()
        event.override(with: draft)
        save()
    }

    func update(_ event: Event, with draft: EventDraft) {

        event.clearCache()
        event.override(with: draft)
        save()
    }

    func delete(_ event: Event) {
        container.viewContext.delete(event)
        save()
    }
}
