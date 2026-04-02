//
//  IncidentRefGenerator.swift
//  NurseryConnect
//

import Foundation

/// Generates a unique incident reference number in the format INC-YYYYMMDD-NNN.
/// Example: INC-20260412-003
///
/// - Parameters:
///   - date: The date of the incident (used for the YYYYMMDD portion).
///   - existingCount: The total number of incident reports already in the store.
///                    The new report gets number existingCount + 1.
/// - Returns: A formatted reference string, e.g. "INC-20260412-003"
func generateRef(date: Date, existingCount: Int) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let datePart = formatter.string(from: date)
    let number = existingCount + 1
    let numberPart = String(format: "%03d", number)
    return "INC-\(datePart)-\(numberPart)"
}
