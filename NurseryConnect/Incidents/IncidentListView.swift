//
//  IncidentListView.swift
//  NurseryConnect
//
//  Created by Udula on 2026-04-02.
//

import SwiftUI
import _SwiftData_SwiftUI

struct IncidentListView: View {
    @Query(sort: \IncidentReport.incidentDate, order: .reverse)
    private var reports: [IncidentReport]

    @State private var statusFilter: IncidentStatus? = nil
    @State private var showingNewIncident = false
    @State private var selectedReport: IncidentReport?

    private var filtered: [IncidentReport] {
        guard let filter = statusFilter else { return reports }
        return reports.filter { $0.status == filter }
    }

    var body: some View {
        Group {
            if filtered.isEmpty {
                ContentUnavailableView(
                    statusFilter == nil ? "No Incidents" : "No \(statusFilter!.rawValue) Incidents",
                    systemImage: "checkmark.shield",
                    description: Text(
                        statusFilter == nil
                            ? "No incident reports have been filed."
                            : "No incidents with this status."
                    )
                )
            } else {
                List(filtered) { report in
                    // Placeholder row — replaced on Day 10
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        HStack {
                            Text(report.referenceNumber)
                                .font(.cardTitle)
                            Spacer()
                            Text(report.status.rawValue)
                                .font(.bodySmall.bold())
                                .foregroundStyle(.white)
                                .padding(.horizontal, AppSpacing.sm)
                                .padding(.vertical, AppSpacing.xs)
                                .background(Capsule().fill(report.status.color))
                        }
                        Text(report.category.rawValue)
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                        Text(report.incidentDate, style: .date)
                            .font(.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, AppSpacing.xs)
                    .onTapGesture { selectedReport = report }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Incidents")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Button("All") { statusFilter = nil }
                    Divider()
                    ForEach(IncidentStatus.allCases, id: \.self) { status in
                        Button(status.rawValue) { statusFilter = status }
                    }
                } label: {
                    Label(
                        statusFilter?.rawValue ?? "All",
                        systemImage: "line.3.horizontal.decrease.circle"
                    )
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingNewIncident = true
                } label: {
                    Label("New Incident", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingNewIncident) {
            // NewIncidentFlow added on Day 11
            Text("New Incident Form — coming Day 11")
                .presentationDetents([.medium])
        }
        .navigationDestination(item: $selectedReport) { report in
            // IncidentDetailView added on Day 14
            Text("Detail for \(report.referenceNumber) — coming Day 14")
                .navigationTitle(report.referenceNumber)
        }
    }
}

#Preview {
    NavigationStack {
        IncidentListView()
    }
    .modelContainer(SampleData.previewContainer)
}

