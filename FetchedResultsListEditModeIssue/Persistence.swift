//
//  Persistence.swift
//  FetchedResultsListEditModeIssue
//
//  Created by Gene Bogdanovich on 29.03.22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FetchedResultsListEditModeIssue")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
