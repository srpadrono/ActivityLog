import Foundation
import Combine

// Simple protocol to abstract time for deterministic tests
protocol Clock {
    func now() -> Date
}

struct SystemClock: Clock {
    func now() -> Date { Date() }
}

struct Entry: Equatable {
    let activityId: UUID
    let startAt: Date
    var endAt: Date?

    var isRunning: Bool { endAt == nil }
}

final class ActivityTimerController: ObservableObject {
    @Published private(set) var currentEntry: Entry?
    @Published private(set) var entries: [Entry] = []

    private let clock: Clock

    init(clock: Clock = SystemClock()) {
        self.clock = clock
    }

    // One-tap behavior: start if idle, stop if tapping active, switch if different
    func tap(activityId: UUID) {
        if let running = currentEntry {
            if running.activityId == activityId {
                stop()
            } else {
                switchTo(activityId: activityId)
            }
        } else {
            start(activityId: activityId)
        }
    }

    func start(activityId: UUID) {
        guard currentEntry == nil else { return }
        let now = clock.now()
        currentEntry = Entry(activityId: activityId, startAt: now, endAt: nil)
    }

    func stop() {
        guard var running = currentEntry else { return }
        let now = clock.now()
        running.endAt = now
        entries.append(running)
        currentEntry = nil
    }

    // Zero-gap auto-switching: close current and start new at identical timestamp
    func switchTo(activityId: UUID) {
        let now = clock.now()
        if var running = currentEntry {
            running.endAt = now
            entries.append(running)
        }
        currentEntry = Entry(activityId: activityId, startAt: now, endAt: nil)
    }

    func isRunning(activityId: UUID) -> Bool {
        currentEntry?.activityId == activityId
    }

    func elapsed(for activityId: UUID) -> TimeInterval {
        if let running = currentEntry, running.activityId == activityId {
            return clock.now().timeIntervalSince(running.startAt)
        }
        return 0
    }
}

