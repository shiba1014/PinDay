//
//  Persistence.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

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

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "PinDay")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save: \(error.localizedDescription)")
            }
        }
    }

    func create(from draft: EventDraft) {

        let event = Event(context: container.viewContext)
        event.id = UUID()
        event.createdAt = Date()
        event.override(with: draft)
        save()
    }

    func update(_ event: Event, with draft: EventDraft) {

        event.override(with: draft)
        save()
    }

    func delete(_ event: Event) {
        container.viewContext.delete(event)
        save()
    }
}
