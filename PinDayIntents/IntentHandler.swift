//
//  IntentHandler.swift
//  PinDayIntents
//
//  Created by shiba on 2021/05/07.
//

import Intents

class IntentHandler: INExtension, SelectEventIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }

    func resolveEvent(for intent: SelectEventIntent, with completion: @escaping (WidgetEventResolutionResult) -> Void) {

    }

    func provideEventOptionsCollection(for intent: SelectEventIntent, with completion: @escaping (INObjectCollection<WidgetEvent>?, Error?) -> Void) {
        do {
            let events = try PersistenceController.shared.fetchAllEvents()
            let items: [WidgetEvent] = events.map {
                .init(identifier: $0.id.uuidString, display: $0.title)
            }
            let collections = INObjectCollection(items: items)
            completion(collections, nil)
        } catch {
            completion(nil, error)
        }

    }
    
}
