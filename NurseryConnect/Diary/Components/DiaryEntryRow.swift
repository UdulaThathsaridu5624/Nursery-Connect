//
//  DiaryEntryRow.swift
//  NurseryConnect
//

import SwiftUI
import SwiftData

struct DiaryEntryRow: View {
    let entry: DiaryEntry

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {

            // Coloured type icon
            Image(systemName: entry.entryType.systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(entry.entryType.color)
                .frame(width: 36, height: 36)
                .background(entry.entryType.color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(entry.headline)
                    .font(.cardTitle)
                    .foregroundStyle(.primary)

                // Secondary info line: type-specific detail
                if !entry.subtitle.isEmpty {
                    Text(entry.subtitle)
                        .font(.bodySmall)
                        .foregroundStyle(entry.entryType.color.opacity(0.8))
                        .lineLimit(1)
                }

                HStack(spacing: AppSpacing.xs) {
                    Text(entry.timestamp, style: .time)
                        .font(.bodySmall)
                        .foregroundStyle(.secondary)

                    if !entry.notes.isEmpty {
                        Text("·")
                            .foregroundStyle(.secondary)
                        Text(entry.notes)
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }

            Spacer()
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

#Preview {
    let container = SampleData.previewContainer
    let entries = try! container.mainContext.fetch(FetchDescriptor<DiaryEntry>())
    return List(entries) { entry in
        DiaryEntryRow(entry: entry)
    }
    .modelContainer(container)
}
