//
//  SampleData.swift
//  NurseryConnect
//

import Foundation
import SwiftData
import SwiftUI

enum SampleData {

    static let keyworkerName = "Sarah Mitchell"

    @MainActor
    static func insertSampleData(into context: ModelContext) {
        let calendar = Calendar.current
        let today = Date.now

        // MARK: - Children

        let emma = Child(
            fullName: "Emma Johnson",
            preferredName: "Emma",
            dateOfBirth: calendar.date(byAdding: .year, value: -3, to: today)!,
            roomName: "Sunshine Room"
        )
        emma.allergies = ["Peanuts"]
        emma.dietaryNotes = "Nut-free diet. Full-fat dairy."
        emma.medicalNotes = "EpiPen required. Protocol on file."

        let oliver = Child(
            fullName: "Oliver Davies",
            preferredName: "Ollie",
            dateOfBirth: calendar.date(byAdding: DateComponents(year: -2, month: -4), to: today)!,
            roomName: "Sunshine Room"
        )
        oliver.dietaryNotes = "Vegetarian."

        let sophia = Child(
            fullName: "Sophia Patel",
            preferredName: "Sophia",
            dateOfBirth: calendar.date(byAdding: DateComponents(year: -1, month: -8), to: today)!,
            roomName: "Rainbow Room"
        )
        sophia.allergies = ["Dairy", "Eggs"]
        sophia.dietaryNotes = "Dairy-free, egg-free. Full-fat alternatives only."
        sophia.medicalNotes = "Check all labels carefully."

        // MARK: - Diary entries for today

        // Emma
        let emmaArrival = DiaryEntry(entryType: .mood, timestamp: calendar.date(bySettingHour: 8, minute: 30, second: 0, of: today)!, recordedByName: keyworkerName, child: emma)
        emmaArrival.moodLevel = .happy
        emmaArrival.moodContext = "On arrival"
        emmaArrival.notes = "Arrived happy, waved goodbye to mum easily."

        let emmaActivity = DiaryEntry(entryType: .activity, timestamp: calendar.date(bySettingHour: 9, minute: 15, second: 0, of: today)!, recordedByName: keyworkerName, child: emma)
        emmaActivity.activityTitle = "Outdoor Play"
        emmaActivity.activityCategory = "Outdoor Play"
        emmaActivity.activityDescription = "Enjoyed the climbing frame and sandpit with friends."

        let emmaNap = DiaryEntry(entryType: .sleep, timestamp: calendar.date(bySettingHour: 12, minute: 30, second: 0, of: today)!, recordedByName: keyworkerName, child: emma)
        emmaNap.sleepStart = calendar.date(bySettingHour: 12, minute: 30, second: 0, of: today)
        emmaNap.sleepEnd = calendar.date(bySettingHour: 13, minute: 45, second: 0, of: today)
        emmaNap.sleepPosition = .back

        let emmaLunch = DiaryEntry(entryType: .meal, timestamp: calendar.date(bySettingHour: 11, minute: 45, second: 0, of: today)!, recordedByName: keyworkerName, child: emma)
        emmaLunch.mealName = "Lunch"
        emmaLunch.mealAmount = .most
        emmaLunch.fluidAmountMl = 150
        emmaLunch.fluidType = "Water"

        let emmaNappy = DiaryEntry(entryType: .nappy, timestamp: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!, recordedByName: keyworkerName, child: emma)
        emmaNappy.nappyType = .wet
        emmaNappy.creamApplied = false

        // Oliver
        let oliverMorningSnack = DiaryEntry(entryType: .meal, timestamp: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today)!, recordedByName: keyworkerName, child: oliver)
        oliverMorningSnack.mealName = "Morning Snack"
        oliverMorningSnack.mealAmount = .all
        oliverMorningSnack.fluidAmountMl = 120
        oliverMorningSnack.fluidType = "Milk"

        let oliverActivity = DiaryEntry(entryType: .activity, timestamp: calendar.date(bySettingHour: 9, minute: 30, second: 0, of: today)!, recordedByName: keyworkerName, child: oliver)
        oliverActivity.activityTitle = "Story Time"
        oliverActivity.activityCategory = "Story Time"
        oliverActivity.activityDescription = "Listened attentively to 'The Very Hungry Caterpillar'."

        let oliverMood = DiaryEntry(entryType: .mood, timestamp: calendar.date(bySettingHour: 8, minute: 45, second: 0, of: today)!, recordedByName: keyworkerName, child: oliver)
        oliverMood.moodLevel = .veryHappy
        oliverMood.moodContext = "On arrival"

        // Sophia
        let sophiaNappy = DiaryEntry(entryType: .nappy, timestamp: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: today)!, recordedByName: keyworkerName, child: sophia)
        sophiaNappy.nappyType = .both
        sophiaNappy.creamApplied = true

        let sophiaNap = DiaryEntry(entryType: .sleep, timestamp: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: today)!, recordedByName: keyworkerName, child: sophia)
        sophiaNap.sleepStart = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: today)
        sophiaNap.sleepEnd = calendar.date(bySettingHour: 12, minute: 15, second: 0, of: today)
        sophiaNap.sleepPosition = .back

        // MARK: - Incident Reports

        let incident1 = IncidentReport(
            referenceNumber: "INC-20260329-001",
            category: .bump,
            severity: .minor,
            status: .parentNotified,
            incidentDate: calendar.date(byAdding: .day, value: -2, to: today)!,
            location: "Outdoor play area",
            descriptionOfIncident: "Emma tripped on uneven ground near the sandpit and bumped her knee on the decking.",
            immediateActionTaken: "Applied cold compress for 5 minutes. No swelling observed. Child settled quickly and returned to play.",
            reportedByName: keyworkerName,
            child: emma
        )
        incident1.injuryDescription = "Small red mark on left knee. No broken skin."
        incident1.witnessNames = ["Rachel Green"]
        incident1.reviewedByName = "Mrs T. Williams"
        incident1.reviewedAt = calendar.date(byAdding: .hour, value: 1, to: calendar.date(byAdding: .day, value: -2, to: today)!)
        incident1.parentNotifiedAt = calendar.date(byAdding: .hour, value: 2, to: calendar.date(byAdding: .day, value: -2, to: today)!)
        incident1.parentNotificationMethod = "In Person"
        incident1.parentSignatureObtained = true

        let incident2 = IncidentReport(
            referenceNumber: "INC-20260331-001",
            category: .fall,
            severity: .minor,
            status: .pendingReview,
            incidentDate: today,
            location: "Sunshine Room",
            descriptionOfIncident: "Oliver climbed onto a low step stool during free play and lost balance, falling onto the carpeted floor.",
            immediateActionTaken: "Child comforted immediately. Head checked — no visible injury. Child was alert and responsive throughout.",
            reportedByName: keyworkerName,
            child: oliver
        )
        incident2.injuryDescription = "No visible injury. Child cried for approximately 2 minutes then returned to play."

        // MARK: - Insert all

        let allModels: [any PersistentModel] = [
            emma, oliver, sophia,
            emmaArrival, emmaActivity, emmaNap, emmaLunch, emmaNappy,
            oliverMorningSnack, oliverActivity, oliverMood,
            sophiaNappy, sophiaNap,
            incident1, incident2
        ]

        for model in allModels {
            context.insert(model)
        }
    }

    // MARK: - Preview Container

    @MainActor
    static var previewContainer: ModelContainer {
        let schema = Schema([Child.self, DiaryEntry.self, IncidentReport.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        insertSampleData(into: container.mainContext)
        return container
    }
}
