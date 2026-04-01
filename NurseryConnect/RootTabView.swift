//
//  RootTabView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct RootTabView: View {
    var body: some View {
        TabView {
            Tab("Daily Diary", systemImage: "book.fill") {
                NavigationStack {
                    DiaryDashboardView()
                }
            }

            Tab("Incidents", systemImage: "exclamationmark.triangle.fill") {
                NavigationStack {
                    IncidentListView()
                }
            }
        }
        .tint(Color.nurseryPrimary)
    }
}

#Preview {
    RootTabView()
        .modelContainer(SampleData.previewContainer)
}
