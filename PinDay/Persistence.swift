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
            let entity = EventEntity(context: viewContext)
            entity.id = UUID()
            entity.createdAt = Date()

            if i%3 == 0 {
                let date = Date().fixed(month: 1, day: 1)
                entity.title = "\(date.year)"
                entity.pinnedDate = date
                entity.backgroundColor = Data.encode(color: .orange)
            }
            else if i%3 == 1 {
                let date = Date().fixed(month: 1, day: 1).added(year: 1)
                entity.title = "New Year"
                entity.pinnedDate = date
                entity.backgroundColor = Data.encode(color: .yellow)
            }
            else {
                let date = Date().fixed(month: 12, day: 31)
                entity.title = "\(date.year)"
                entity.pinnedDate = date
                entity.startDate = Date().fixed(month: 1, day: 1)
                entity.backgroundColor = Data.encode(color: .pink)
            }
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

        let event = EventEntity(context: container.viewContext)
        event.id = UUID()
        event.createdAt = Date()
        event.override(with: draft)
        save()
    }

    func update(_ event: EventEntity, with draft: EventDraft) {

        event.override(with: draft)
        save()
    }

    func delete(_ event: EventEntity) {
        container.viewContext.delete(event)
        save()
    }
}
