//
//  IncidentRowView.swift
//  NurseryConnect
//
//  Created by Udula on 2026-04-09.
//

import SwiftUI
import SwiftData

struct IncidentRowView: View {
    let report: IncidentReport

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {

            // Severity colour indicator
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(report.severity.color)
                .frame(width: 36, height: 36)
                .background(report.severity.color.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                // Reference number + child name
                HStack(spacing: AppSpacing.xs) {
                    Text(report.referenceNumber)
                        .font(.cardTitle)
                        .foregroundStyle(.primary)
                }

                // Category + child name
                Text(report.category.rawValue + (report.child != nil ? " · \(report.child!.preferredName)" : ""))
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                // Date
                Text(report.incidentDate, style: .date)
                    .font(.bodySmall)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            StatusBadge(status: report.status)
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

#Preview {
    let container = SampleData.previewContainer
    let reports = try! container.mainContext.fetch(FetchDescriptor<IncidentReport>())
    return List(reports) { report in
        IncidentRowView(report: report)
    }
    .modelContainer(container)
}
