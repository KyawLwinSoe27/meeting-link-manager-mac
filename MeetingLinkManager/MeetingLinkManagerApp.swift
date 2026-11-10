//
//  MeetingLinkManagerApp.swift
//  MeetingLinkManager
//
//  Created by Kyaw Lwin Soe on 10/11/2026.
//

import SwiftUI
import SwiftData

@main
struct MeetingLinkManagerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
