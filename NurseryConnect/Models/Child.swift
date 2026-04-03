//
//  Child.swift
//  NurseryConnect
//
//  Created by Udula on 2026-04-02.
//

import Foundation
import SwiftData

@Model
final class Child {
    var id: UUID = UUID()
    var fullName: String
    var preferredName: String
    var dateOfBirth: Date
    var roomName: String
    var allergies: [String] = []
    var dietaryNotes: String = ""
    var medicalNotes: String = ""
    var isActive: Bool = true
    var photoData: Data?

    @Relationship(deleteRule: .cascade)
    var diaryEntries: [DiaryEntry] = []

    @Relationship(deleteRule: .cascade)
    var incidentReports: [IncidentReport] = []

    init(fullName: String,
         preferredName: String,
         dateOfBirth: Date,
         roomName: String) {
        self.fullName = fullName
        self.preferredName = preferredName
        self.dateOfBirth = dateOfBirth
        self.roomName = roomName
    }

    var initials: String {
        let parts = fullName.split(separator: " ").prefix(2)
        return parts.compactMap { $0.first.map(String.init) }.joined()
    }

    var age: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: dateOfBirth, to: Date.now)
        let years = components.year ?? 0
        let months = components.month ?? 0
        if years == 0 {
            return "\(months) month\(months == 1 ? "" : "s")"
        } else if months == 0 {
            return "\(years)y"
        } else {
            return "\(years)y \(months)m"
        }
    }

    var diaryEntriesForToday: [DiaryEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date.now)
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        return diaryEntries.filter { $0.timestamp >= today && $0.timestamp < tomorrow }
    }

    func diaryEntries(for date: Date) -> [DiaryEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        return diaryEntries
            .filter { $0.timestamp >= startOfDay && $0.timestamp < endOfDay }
            .sorted { $0.timestamp < $1.timestamp }
    }
}
