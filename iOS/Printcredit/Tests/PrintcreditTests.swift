import XCTest
@testable import Printcredit

@MainActor
final class PrintcreditTests: XCTestCase {

    func makeStore() -> Store {
        let store = Store()
        store.items = []
        store.save()
        return store
    }

    func testInitialSeedBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = makeStore()
        let before = store.items.count
        store.add(PrintJob(job: "Test", pages: 1, course: "Test"))
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = makeStore()
        let item = PrintJob(job: "Test", pages: 1, course: "Test")
        store.add(item)
        XCTAssertTrue(store.items.contains(item))
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = makeStore()
        store.isPro = false
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        let store = makeStore()
        store.isPro = false
        for i in 0..<Store.freeLimit {
            store.add(PrintJob(job: "Item \(i)", pages: i, course: "Item \(i)"))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testProUsersCanAlwaysAdd() {
        let store = makeStore()
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(PrintJob(job: "Item \(i)", pages: i, course: "Item \(i)"))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testPersistenceRoundTrip() {
        let store = makeStore()
        let item = PrintJob(job: "Test", pages: 1, course: "Test")
        store.add(item)
        let reloaded = Store()
        XCTAssertTrue(reloaded.items.contains(where: { $0.id == item.id }))
    }
}
