//
//  Persistence.swift
//  PinDay
//
//  Created by Satsuki Hashiba on 2021/04/06.
//

import CoreData
import WidgetKit

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {

        container = NSPersistentCloudKitContainer(name: "PinDay")
        let storeURL = FileManager.appGroupContainerURL.appendingPathComponent("PinDay.sqlite")
        container.persistentStoreDescriptions = [.init(url: storeURL)]

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
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                print("Failed to save: \(error.localizedDescription)")
            }
        }
    }

    func fetchAllEvents() throws -> [Event] {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        return try container.viewContext.fetch(request)
    }

    func fetchEvent(_ uuidStr: String) -> Event? {
        let request: NSFetchRequest<Event> = Event.fetchRequest()
        request.predicate = .init(format: "id = %@", uuidStr)
        do {
            let result = try container.viewContext.fetch(request)
            return result.first
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
            return nil
        }
    }
}

extension FileManager {
    static let appGroupContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.shiba1014.PinDay")!
}
