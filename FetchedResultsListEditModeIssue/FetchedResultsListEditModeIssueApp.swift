//
//  FetchedResultsListEditModeIssueApp.swift
//  FetchedResultsListEditModeIssue
//
//  Created by Gene Bogdanovich on 29.03.22.
//

import SwiftUI

@main
struct FetchedResultsListEditModeIssueApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
