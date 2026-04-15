//
//  NurseryConnectTests.swift
//  NurseryConnectTests
//
//  Created by Udula on 2026-03-30.
//

import Testing
import Foundation
import SwiftData
@testable import NurseryConnect

// MARK: - Helpers

private func makeContainer<T: PersistentModel>(for type: T.Type) throws -> ModelContainer {
    try ModelContainer(
        for: type,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
}

private func date(year: Int, month: Int, day: Int) -> Date {
    var c = DateComponents()
    c.year = year; c.month = month; c.day = day
    return Calendar.current.date(from: c)!
}

// MARK: - Test Suite

@Suite("NurseryConnect Unit Tests")
struct NurseryConnectTests {

    // MARK: 1 — Child.age: infant under 1 year

    @Test("Child.age returns 'X months' for infants under one year")
    func childAgeInfant() throws {
        let container = try makeContainer(for: Child.self)
        let ctx = ModelContext(container)
        let dob = Calendar.current.date(byAdding: .month, value: -8, to: .now)!
        let child = Child(fullName: "Baby Test", preferredName: "Baby",
                          dateOfBirth: dob, roomName: "Babies")
        ctx.insert(child)
        #expect(child.age == "8 months")
    }

    // MARK: 2 — Child.age: toddler over 1 year

    @Test("Child.age returns 'Xy Zm' for children over one year")
    func childAgeToddler() throws {
        let container = try makeContainer(for: Child.self)
        let ctx = ModelContext(container)
        var comps = DateComponents()
        comps.year = -2; comps.month = -3
        let dob = Calendar.current.date(byAdding: comps, to: .now)!
        let child = Child(fullName: "Toddler Test", preferredName: "Toddler",
                          dateOfBirth: dob, roomName: "Toddlers")
        ctx.insert(child)
        #expect(child.age == "2y 3m")
    }

    // MARK: 3 — Child.initials

    @Test("Child.initials extracts first letter of each name part")
    func childInitials() throws {
        let container = try makeContainer(for: Child.self)
        let ctx = ModelContext(container)
        let child = Child(fullName: "Emma Johnson", preferredName: "Emma",
                          dateOfBirth: .now, roomName: "Pre-School")
        ctx.insert(child)
        #expect(child.initials == "EJ")
    }

    // MARK: 4 — generateRef: correct INC-YYYYMMDD-NNN format

    @Test("generateRef produces correct INC-YYYYMMDD-NNN format")
    func generateRefFormat() {
        let ref = generateRef(date: date(year: 2026, month: 4, day: 15), existingCount: 0)
        #expect(ref == "INC-20260415-001")
    }

    // MARK: 5 — generateRef: increments from existing count

    @Test("generateRef pads and increments from existing count correctly")
    func generateRefIncrement() {
        let ref = generateRef(date: date(year: 2026, month: 4, day: 15), existingCount: 4)
        #expect(ref == "INC-20260415-005")
    }

    // MARK: 6 — BodyMapMark JSON encode/decode round-trip

    @Test("BodyMapMark JSON round-trip preserves all fields")
    @MainActor
    func bodyMapMarkRoundTrip() throws {
        let fixedID = UUID()
        let mark = BodyMapMark(id: fixedID, xNormalized: 0.45, yNormalized: 0.72,
                               isFrontView: true, label: "Front")
        let data = try JSONEncoder().encode(mark)
        let decoded = try JSONDecoder().decode(BodyMapMark.self, from: data)
        #expect(decoded.id == fixedID)
        #expect(decoded.xNormalized == 0.45)
        #expect(decoded.yNormalized == 0.72)
        #expect(decoded.isFrontView == true)
        #expect(decoded.label == "Front")
    }

    // MARK: 7 — DiaryEntry sleep duration

    @Test("DiaryEntry.sleepDurationMinutes computes 60 minutes correctly")
    func sleepDuration() throws {
        let container = try makeContainer(for: DiaryEntry.self)
        let ctx = ModelContext(container)
        let entry = DiaryEntry(entryType: .sleep, timestamp: .now,
                               recordedByName: "Sarah Mitchell")
        let start = Date.now
        entry.sleepStart = start
        entry.sleepEnd   = start.addingTimeInterval(60 * 60) // 1 hour = 60 min
        ctx.insert(entry)
        #expect(entry.sleepDurationMinutes == 60)
    }

    // MARK: 8a — IncidentStatus workflow: draft → pendingReview

    @Test("IncidentReport.nextStatuses — draft transitions only to pendingReview")
    func statusWorkflowDraft() throws {
        let container = try makeContainer(for: IncidentReport.self)
        let ctx = ModelContext(container)
        let report = IncidentReport(
            referenceNumber: "INC-20260415-001",
            category: .bump, severity: .minor,
            incidentDate: .now, location: "Playground",
            descriptionOfIncident: "Test incident",
            immediateActionTaken: "First aid applied",
            reportedByName: "Sarah Mitchell"
        )
        report.status = IncidentStatus.draft
        ctx.insert(report)
        #expect(report.nextStatuses == [.pendingReview])
    }

    // MARK: 8b — IncidentStatus workflow: closed has no transitions

    @Test("IncidentReport.nextStatuses — closed status has no further transitions")
    func statusWorkflowClosed() throws {
        let container = try makeContainer(for: IncidentReport.self)
        let ctx = ModelContext(container)
        let report = IncidentReport(
            referenceNumber: "INC-20260415-002",
            category: .fall, severity: .moderate,
            incidentDate: .now, location: "Garden",
            descriptionOfIncident: "Test incident",
            immediateActionTaken: "Comfort provided",
            reportedByName: "Sarah Mitchell"
        )
        report.status = IncidentStatus.closed
        ctx.insert(report)
        #expect(report.nextStatuses.isEmpty)
    }
}
