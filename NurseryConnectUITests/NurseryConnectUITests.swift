//
//  NurseryConnectUITests.swift
//  NurseryConnectUITests
//
//  Created by Udula on 2026-03-30.
//

import XCTest

final class NurseryConnectUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: 1 — App launches and shows both tabs

    @MainActor
    func testAppLaunchShowsTabs() throws {
        XCTAssertTrue(app.tabBars.buttons["Daily Diary"].exists)
        XCTAssertTrue(app.tabBars.buttons["Incidents"].exists)
    }

    // MARK: 2 — Diary tab: tapping a child card navigates to diary view

    @MainActor
    func testTapChildCardNavigatesToDiary() throws {
        // Sample data seeds "Emma" — her preferred name appears on the card
        let emmaCard = app.staticTexts["Emma"]
        XCTAssertTrue(emmaCard.waitForExistence(timeout: 3))
        emmaCard.tap()

        // ChildDiaryView navigation title is the child's preferred name
        XCTAssertTrue(app.navigationBars["Emma"].waitForExistence(timeout: 3))
    }

    // MARK: 3 — Diary view: tapping FAB shows entry type picker sheet

    @MainActor
    func testFABOpensEntryTypePicker() throws {
        let emmaCard = app.staticTexts["Emma"]
        XCTAssertTrue(emmaCard.waitForExistence(timeout: 3))
        emmaCard.tap()

        // Tap the floating + button (accessibility label comes from SF Symbol "plus")
        let fab = app.buttons["plus"]
        XCTAssertTrue(fab.waitForExistence(timeout: 3))
        fab.tap()

        // EntryTypePicker shows "Activity" as a tappable button row
        XCTAssertTrue(app.buttons["Activity"].waitForExistence(timeout: 3))
    }

    // MARK: 4 — Add an Activity entry and verify it appears in the diary list

    @MainActor
    func testAddActivityEntry() throws {
        // Navigate to Emma's diary
        let emmaCard = app.staticTexts["Emma"]
        XCTAssertTrue(emmaCard.waitForExistence(timeout: 3))
        emmaCard.tap()

        // Open entry type picker
        let fab = app.buttons["plus"]
        XCTAssertTrue(fab.waitForExistence(timeout: 3))
        fab.tap()

        // Choose Activity from the picker (List rows are exposed as Buttons)
        let activityRow = app.buttons["Activity"]
        XCTAssertTrue(activityRow.waitForExistence(timeout: 3))
        activityRow.tap()

        // Fill in the activity title
        let titleField = app.textFields["Activity title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 3))
        titleField.tap()
        titleField.typeText("Painting")

        // Save
        app.buttons["Save"].tap()

        // The new entry headline should appear in the diary list
        XCTAssertTrue(app.staticTexts["Painting"].waitForExistence(timeout: 3))
    }

    // MARK: 5 — Incidents tab: tapping "+" opens New Incident sheet

    @MainActor
    func testNewIncidentButtonOpensSheet() throws {
        app.tabBars.buttons["Incidents"].tap()

        let addButton = app.navigationBars["Incidents"].buttons["New Incident"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 3))
        addButton.tap()

        // Sheet title
        XCTAssertTrue(app.navigationBars["New Incident Report"].waitForExistence(timeout: 3))
    }

    // MARK: 6 — New incident form: step structure and Next button validation

    @MainActor
    func testNewIncidentFormStepStructure() throws {
        app.tabBars.buttons["Incidents"].tap()
        app.navigationBars["Incidents"].buttons["New Incident"].tap()
        XCTAssertTrue(app.navigationBars["New Incident Report"].waitForExistence(timeout: 3))

        // Step 1 is shown — progress label and Next button exist
        XCTAssertTrue(app.staticTexts["Step 1 of 4"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Next"].exists)

        // Next is disabled until child + location are filled (validation enforced)
        XCTAssertFalse(app.buttons["Next"].isEnabled)

        // Cancel returns to the incidents list
        app.buttons["Cancel"].tap()
        XCTAssertTrue(app.navigationBars["Incidents"].waitForExistence(timeout: 3))
    }

    // MARK: 7 — Incident detail: advance status from Pending Review → Reviewed & Approved

    @MainActor
    func testAdvanceIncidentStatus() throws {
        app.tabBars.buttons["Incidents"].tap()

        // Sample data seeds a "Pending Review" report — find it
        let pendingBadge = app.staticTexts["Pending Review"]
        XCTAssertTrue(pendingBadge.waitForExistence(timeout: 3))
        pendingBadge.tap()

        // Tap "Update Status" toolbar menu
        let updateStatus = app.buttons["Update Status"]
        XCTAssertTrue(updateStatus.waitForExistence(timeout: 3))
        updateStatus.tap()

        // Choose "Reviewed & Approved"
        let approveButton = app.buttons["Reviewed & Approved"]
        XCTAssertTrue(approveButton.waitForExistence(timeout: 3))
        approveButton.tap()

        // Badge on detail view should now read "Reviewed & Approved"
        XCTAssertTrue(app.staticTexts["Reviewed & Approved"].waitForExistence(timeout: 3))
    }
}
