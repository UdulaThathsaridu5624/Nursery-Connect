//
//  ActivityEntryForm.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct ActivityEntryForm: View {
    let child: Child

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var activityCategory = "Outdoor Play"
    @State private var activityTitle    = ""
    @State private var description      = ""
    @State private var notes            = ""
    @State private var timestamp        = Date.now

    let categories = [
        "Outdoor Play", "Art & Craft", "Story Time",
        "Music & Movement", "Sensory Play", "Messy Play",
        "Physical Play", "Role Play", "Educational"
    ]

    private var isSaveDisabled: Bool {
        activityTitle.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Activity") {
                    Picker("Category", selection: $activityCategory) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    .onChange(of: activityCategory) { _, newValue in
                        if activityTitle.isEmpty {
                            activityTitle = newValue
                        }
                    }

                    TextField("Activity title", text: $activityTitle)

                    DatePicker("Time", selection: $timestamp,
                               displayedComponents: .hourAndMinute)
                        .tint(Color.nurseryPrimary)
                }

                Section("Description") {
                    TextEditor(text: $description)
                        .frame(minHeight: 80)
                        .overlay(alignment: .topLeading) {
                            if description.isEmpty {
                                Text("What did \(child.preferredName) do?")
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                }

                Section("Additional Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 60)
                        .overlay(alignment: .topLeading) {
                            if notes.isEmpty {
                                Text("Any observations...")
                                    .foregroundStyle(.secondary)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                    .allowsHitTesting(false)
                            }
                        }
                }
            }
            .navigationTitle("Log Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(isSaveDisabled)
                        .fontWeight(.semibold)
                }
            }
        }
        .presentationCornerRadius(20)
    }

    private func save() {
        let entry = DiaryEntry(
            entryType: .activity,
            timestamp: timestamp,
            recordedByName: SampleData.keyworkerName,
            child: child
        )
        entry.activityCategory    = activityCategory
        entry.activityTitle       = activityTitle.trimmingCharacters(in: .whitespaces)
        entry.activityDescription = description
        entry.notes               = notes
        modelContext.insert(entry)
        dismiss()
    }
}

#Preview {
    let container = SampleData.previewContainer
    let child = try! container.mainContext.fetch(FetchDescriptor<Child>()).first!
    return ActivityEntryForm(child: child)
        .modelContainer(container)
}
