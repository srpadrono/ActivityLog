import XCTest
@testable import ActivityLog

final class FakeClock: Clock {
    private var current: Date
    init(start: Date) { self.current = start }
    func now() -> Date { current }
    func advance(_ seconds: TimeInterval) { current = current.addingTimeInterval(seconds) }
}

final class ActivityTimerControllerTests: XCTestCase {
    func testStartOnTapBeginsEntry() {
        let clock = FakeClock(start: Date(timeIntervalSince1970: 1_000))
        let controller = ActivityTimerController(clock: clock)
        let activityA = UUID()

        controller.tap(activityId: activityA)

        XCTAssertNotNil(controller.currentEntry)
        XCTAssertEqual(controller.currentEntry?.activityId, activityA)
        XCTAssertEqual(controller.currentEntry?.startAt, clock.now())
        XCTAssertTrue(controller.entries.isEmpty)
    }

    func testSecondTapStopsEntry() {
        let clock = FakeClock(start: Date(timeIntervalSince1970: 2_000))
        let controller = ActivityTimerController(clock: clock)
        let activityA = UUID()

        controller.tap(activityId: activityA) // start
        clock.advance(5)
        controller.tap(activityId: activityA) // stop

        XCTAssertNil(controller.currentEntry)
        XCTAssertEqual(controller.entries.count, 1)
        let saved = controller.entries.first!
        XCTAssertEqual(saved.activityId, activityA)
        XCTAssertEqual(saved.startAt, Date(timeIntervalSince1970: 2_000))
        XCTAssertEqual(saved.endAt, Date(timeIntervalSince1970: 2_005))
    }

    func testSwitchCreatesZeroGap() {
        let clock = FakeClock(start: Date(timeIntervalSince1970: 3_000))
        let controller = ActivityTimerController(clock: clock)
        let activityA = UUID()
        let activityB = UUID()

        controller.tap(activityId: activityA) // start A at t0
        clock.advance(7)
        controller.tap(activityId: activityB) // switch at t0+7

        // A should be saved with endAt == B.startAt
        XCTAssertEqual(controller.entries.count, 1)
        let a = controller.entries.first!
        XCTAssertEqual(a.activityId, activityA)
        XCTAssertEqual(a.startAt, Date(timeIntervalSince1970: 3_000))
        XCTAssertEqual(a.endAt, Date(timeIntervalSince1970: 3_007))

        // B is running starting at same instant
        XCTAssertEqual(controller.currentEntry?.activityId, activityB)
        XCTAssertEqual(controller.currentEntry?.startAt, Date(timeIntervalSince1970: 3_007))
        XCTAssertNil(controller.currentEntry?.endAt)
    }

    func testIsRunningAndElapsed() {
        let clock = FakeClock(start: Date(timeIntervalSince1970: 4_000))
        let controller = ActivityTimerController(clock: clock)
        let activityA = UUID()
        let activityB = UUID()

        controller.tap(activityId: activityA)
        XCTAssertTrue(controller.isRunning(activityId: activityA))
        XCTAssertFalse(controller.isRunning(activityId: activityB))
        XCTAssertEqual(controller.elapsed(for: activityA), 0, accuracy: 0.001)

        clock.advance(3)
        XCTAssertEqual(controller.elapsed(for: activityA), 3, accuracy: 0.001)
    }
}

