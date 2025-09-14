import XCTest
@testable import ActivityLog

final class TestClock: Clock {
    private var current: Date
    init(start: Date) { self.current = start }
    func now() -> Date { current }
    func advance(_ seconds: TimeInterval) { current = current.addingTimeInterval(seconds) }
}

final class FakeStore: RunningStateStore {
    private(set) var saved: Entry?
    var toLoad: Entry?
    func save(currentEntry: Entry?) { saved = currentEntry }
    func loadCurrentEntry() -> Entry? { toLoad }
}

final class ActivityTimerControllerGuardAndInsertTests: XCTestCase {
    func testShortEntryDiscardedOnStop() {
        let clock = TestClock(start: Date(timeIntervalSince1970: 5_000))
        let store = FakeStore()
        let controller = ActivityTimerController(clock: clock, store: store)
        let activity = UUID()

        controller.tap(activityId: activity) // start
        clock.advance(5) // < minimumDuration (10s)
        controller.tap(activityId: activity) // stop

        XCTAssertNil(controller.currentEntry)
        XCTAssertEqual(controller.entries.count, 0, "Short entries should be discarded")
        XCTAssertNil(store.saved, "Store cleared after stop")
    }

    func testShortEntryDiscardedOnSwitch() {
        let clock = TestClock(start: Date(timeIntervalSince1970: 6_000))
        let store = FakeStore()
        let controller = ActivityTimerController(clock: clock, store: store)
        let a = UUID(); let b = UUID()

        controller.tap(activityId: a)
        clock.advance(3)
        controller.tap(activityId: b) // switch with <10s duration

        XCTAssertEqual(controller.entries.count, 0, "Short entries should not be saved on switch")
        XCTAssertEqual(controller.currentEntry?.activityId, b)
        XCTAssertEqual(store.saved?.activityId, b)
        XCTAssertEqual(store.saved?.startAt, clock.now())
    }

    func testInsertRejectsOverlap() {
        let clock = TestClock(start: Date(timeIntervalSince1970: 7_000))
        let controller = ActivityTimerController(clock: clock, store: nil)
        let a = UUID()

        // Create a valid saved entry [7000, 7015]
        controller.tap(activityId: a)
        clock.advance(15)
        controller.tap(activityId: a) // stop -> saves entry
        XCTAssertEqual(controller.entries.count, 1)

        // Attempt to insert an entry starting before previous ended -> reject
        let overlap = Entry(activityId: a, startAt: Date(timeIntervalSince1970: 7_010), endAt: Date(timeIntervalSince1970: 7_020))
        XCTAssertFalse(controller.insert(overlap))
        XCTAssertEqual(controller.entries.count, 1)
    }

    func testInsertAllowsBoundaryEquality() {
        let clock = TestClock(start: Date(timeIntervalSince1970: 8_000))
        let controller = ActivityTimerController(clock: clock, store: nil)
        let a = UUID()

        // First entry [8000, 8010]
        controller.tap(activityId: a)
        clock.advance(10)
        controller.tap(activityId: a) // stop -> saves entry
        XCTAssertEqual(controller.entries.count, 1)

        // New entry starting exactly at 8010 should be allowed
        let boundary = Entry(activityId: a, startAt: Date(timeIntervalSince1970: 8_010), endAt: Date(timeIntervalSince1970: 8_020))
        XCTAssertTrue(controller.insert(boundary))
        XCTAssertEqual(controller.entries.count, 2)
    }

    func testRunningStatePersistenceWithStore() {
        let clock = TestClock(start: Date(timeIntervalSince1970: 9_000))
        let store = FakeStore()
        let a = UUID()

        // First session: start and persist running state
        var controller: ActivityTimerController? = ActivityTimerController(clock: clock, store: store)
        controller!.tap(activityId: a)
        XCTAssertEqual(store.saved?.activityId, a)
        XCTAssertEqual(store.saved?.startAt, clock.now())

        // Simulate app termination
        let saved = store.saved
        controller = nil

        // Second session: store will load previous running entry
        store.toLoad = saved
        let restored = ActivityTimerController(clock: clock, store: store)
        XCTAssertEqual(restored.currentEntry?.activityId, a)
        XCTAssertEqual(restored.elapsed(for: a), 0, accuracy: 0.001)
        clock.advance(2)
        XCTAssertEqual(restored.elapsed(for: a), 2, accuracy: 0.001)
    }
}

