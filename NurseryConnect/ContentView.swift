//
//  ContentView.swift
//  NurseryConnect
//
//  Placeholder — will be replaced by RootTabView on Day 2 (April 1).
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "building.2.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color.nurseryPrimary)
            Text("NurseryConnect")
                .font(.displayName)
            Text("Keyworker App")
                .font(.sectionHead)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.nurseryBackground)
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
