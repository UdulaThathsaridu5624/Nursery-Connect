//
//  ChildDiaryView.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct ChildDiaryView: View {
    let child: Child
    let date: Date

    @Environment(\.modelContext) private var modelContext

    @State private var showingEntryTypePicker = false
    @State private var selectedEntryType: DiaryEntryType?

    private var entriesForDate: [DiaryEntry] {
        child.diaryEntries(for: date)
            .sorted { $0.timestamp < $1.timestamp }
    }

    private func entries(for type: DiaryEntryType) -> [DiaryEntry] {
        entriesForDate.filter { $0.entryType == type }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // MARK: Entry list
            Group {
                if entriesForDate.isEmpty {
                    ContentUnavailableView {
                        Label("No Entries Yet", systemImage: "book.closed")
                    } description: {
                        Text("Tap + to add the first entry for \(child.preferredName) today.")
                    }
                } else {
                    List {
                        ForEach(DiaryEntryType.allCases) { type in
                            let typeEntries = entries(for: type)
                            if !typeEntries.isEmpty {
                                Section {
                                    ForEach(typeEntries) { entry in
                                        DiaryEntryRow(entry: entry)
                                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                                Button(role: .destructive) {
                                                    modelContext.delete(entry)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                    }
                                } header: {
                                    Label(type.rawValue, systemImage: type.systemImage)
                                        .foregroundStyle(type.color)
                                        .font(.sectionHead)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }

            // MARK: FAB
            Button {
                showingEntryTypePicker = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.nurseryPrimary)
                    .clipShape(Circle())
                    .shadow(color: Color.nurseryPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .padding(AppSpacing.lg)
        }
        .navigationTitle(child.preferredName)
        .navigationBarTitleDisplayMode(.large)
        .background(Color.nurseryBackground)
        // Step 1: pick entry type
        .sheet(isPresented: $showingEntryTypePicker) {
            EntryTypePicker(selectedType: $selectedEntryType)
        }
        // Step 2: open the correct form (forms added Days 6–8)
        .sheet(item: $selectedEntryType) { type in
            Text("Form for \(type.rawValue) — coming Day 6")
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    let container = SampleData.previewContainer
    let child = try! container.mainContext.fetch(FetchDescriptor<Child>()).first!
    return NavigationStack {
        ChildDiaryView(child: child, date: .now)
    }
    .modelContainer(container)
}
