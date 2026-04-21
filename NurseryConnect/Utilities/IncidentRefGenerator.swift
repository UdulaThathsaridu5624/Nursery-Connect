//
//  IncidentRefGenerator.swift
//  NurseryConnect
//

import Foundation

/// Generates a unique incident reference number in the format INC-YYYY-MM-DD-NNN.
/// Example: INC-2026-04-16-003
///
/// - Parameters:
///   - date: The date of the incident (used for the dated portion).
///   - existingCount: The total number of incident reports already in the store.
///                    The new report gets number existingCount + 1.
/// - Returns: A formatted reference string, e.g. "INC-2026-04-16-003"
func generateRef(date: Date, existingCount: Int) -> String {
    "INC-\(incidentDatePart(from: date))-\(sequencePart(from: existingCount + 1))"
}

func migrateIncidentReferencesIfNeeded(_ reports: [IncidentReport]) -> Bool {
    let sortedReports = reports.sorted {
        if $0.incidentDate != $1.incidentDate {
            return $0.incidentDate < $1.incidentDate
        }
        if $0.referenceNumber != $1.referenceNumber {
            return $0.referenceNumber < $1.referenceNumber
        }
        return $0.id.uuidString < $1.id.uuidString
    }

    var didChange = false
    for (index, report) in sortedReports.enumerated() {
        let expectedReference = generateRef(date: report.incidentDate, existingCount: index)
        guard report.referenceNumber != expectedReference else { continue }
        report.referenceNumber = expectedReference
        didChange = true
    }

    return didChange
}

private func incidentDatePart(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

private func sequencePart(from sequence: Int) -> String {
    String(format: "%03d", sequence)
}
