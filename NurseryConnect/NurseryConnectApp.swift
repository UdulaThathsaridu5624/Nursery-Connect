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
            let context = container.mainContext
            if isUITesting {
                SampleData.insertSampleData(into: context)
            } else {
                // Seed sample data on first launch if store is empty
                let childCount = (try? context.fetchCount(FetchDescriptor<Child>())) ?? 0
                if childCount == 0 {
                    SampleData.insertSampleData(into: context)
                }

                let descriptor = FetchDescriptor<IncidentReport>()
                let reports = (try? context.fetch(descriptor)) ?? []
                if migrateIncidentReferencesIfNeeded(reports) {
                    try? context.save()
                }
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
