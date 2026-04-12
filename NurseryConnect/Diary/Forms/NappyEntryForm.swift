//
//  NappyEntryForm.swift
//  NurseryConnect
//
//  Created by Udula on 2026-04-06.
//

import SwiftUI
import SwiftData

struct NappyEntryForm: View {
    let child: Child

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var nappyType    = NappyType.wet
    @State private var creamApplied = false
    @State private var changedBy    = SampleData.keyworkerName
    @State private var timestamp    = Date.now
    @State private var notes        = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Nappy Check") {
                    DatePicker("Time", selection: $timestamp,
                               displayedComponents: .hourAndMinute)
                        .tint(Color.nurseryPrimary)

                    Picker("Type", selection: $nappyType) {
                        ForEach(NappyType.allCases, id: \.self) { type in
                            Text("\(type.emoji)  \(type.rawValue)").tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Details") {
                    Toggle(isOn: $creamApplied) {
                        Label("Barrier Cream Applied", systemImage: "drop.fill")
                    }
                    .tint(Color.nurseryPrimary)

                    HStack {
                        Text("Changed by")
                            .foregroundStyle(.secondary)
                        Spacer()
                        TextField("Name", text: $changedBy)
                            .multilineTextAlignment(.trailing)
                    }
                }

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                        .overlay(alignment: .topLeading) {
                            if notes.isEmpty {
                                Text("Any concerns or observations...")
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                }
            }
            .navigationTitle("Log Nappy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
        }
        .presentationCornerRadius(20)
    }

    private func save() {
        let entry = DiaryEntry(
            entryType: .nappy,
            timestamp: timestamp,
            recordedByName: changedBy,
            child: child
        )
        entry.nappyType    = nappyType
        entry.creamApplied = creamApplied
        entry.notes        = notes
        modelContext.insert(entry)
        dismiss()
    }
}

#Preview {
    let container = SampleData.previewContainer
    let child = try! container.mainContext.fetch(FetchDescriptor<Child>()).first!
    return NappyEntryForm(child: child)
        .modelContainer(container)
}
