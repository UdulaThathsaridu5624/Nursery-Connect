//
//  NurseryConnectApp.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

@main
struct NurseryConnectApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Child.self,
            DiaryEntry.self,
            IncidentReport.self,
        ])
        let isUITesting = CommandLine.arguments.contains("--uitesting")
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                     isStoredInMemoryOnly: isUITesting)
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            if isUITesting {
                SampleData.insertSampleData(into: container.mainContext)
            }
            return container
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
