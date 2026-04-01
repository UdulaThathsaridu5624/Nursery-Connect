//
//  ContentView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        RootTabView()
    }
}

#Preview {
    ContentView()
        .modelContainer(SampleData.previewContainer)
}
