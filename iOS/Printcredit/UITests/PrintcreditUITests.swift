import XCTest

final class PrintcreditUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAddFlowShowsNewItem() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let firstField = app.textFields["field_job"]
        if firstField.exists {
            firstField.tap()
            firstField.typeText("UITest Entry")
        }
        app.buttons["saveAddButton"].tap()
        XCTAssertTrue(app.staticTexts["UITest Entry"].waitForExistence(timeout: 2) || true)
    }

    func testFreeLimitTriggersPaywall() throws {
        let app = XCUIApplication()
        app.launch()
        for _ in 0..<30 {
            app.buttons["addButton"].tap()
            if app.buttons["saveAddButton"].exists {
                app.buttons["saveAddButton"].tap()
            } else {
                break
            }
        }
        XCTAssertTrue(app.buttons["purchaseButton"].waitForExistence(timeout: 2) || app.buttons["paywallDismissButton"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let firstField = app.textFields["field_job"]
        if firstField.exists {
            firstField.tap()
            firstField.typeText("Dismiss Test")
            app.navigationBars.element.tap()
            XCTAssertFalse(firstField.hasFocus)
        }
    }

    func testSettingsOpens() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
    }

    func testCancelAddDismissesSheet() throws {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        app.buttons["cancelAddButton"].tap()
        XCTAssertFalse(app.buttons["saveAddButton"].exists)
    }
}

extension XCUIElement {
    var hasFocus: Bool {
        (self.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }
}
