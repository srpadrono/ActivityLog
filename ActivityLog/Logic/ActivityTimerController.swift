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

// Storage protocol to persist/restore running state (for background/termination)
protocol RunningStateStore {
    func save(currentEntry: Entry?)
    func loadCurrentEntry() -> Entry?
}

struct UserDefaultsRunningStateStore: RunningStateStore {
    private let defaults: UserDefaults
    private let key = "ActivityLog.RunningState"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func save(currentEntry: Entry?) {
        if let entry = currentEntry {
            let payload: [String: Any] = [
                "activityId": entry.activityId.uuidString,
                "startAt": entry.startAt.timeIntervalSince1970
            ]
            defaults.set(payload, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }

    func loadCurrentEntry() -> Entry? {
        guard let payload = defaults.dictionary(forKey: key) else { return nil }
        guard let idStr = payload["activityId"] as? String,
              let id = UUID(uuidString: idStr),
              let startTs = payload["startAt"] as? TimeInterval
        else { return nil }
        return Entry(activityId: id, startAt: Date(timeIntervalSince1970: startTs), endAt: nil)
    }
}

final class ActivityTimerController: ObservableObject {
    @Published private(set) var currentEntry: Entry?
    @Published private(set) var entries: [Entry] = []

    private let clock: Clock
    private let store: RunningStateStore?

    // Minimum duration guard (accidental-tap suppression)
    private let minimumDuration: TimeInterval = 10

    init(clock: Clock = SystemClock(), store: RunningStateStore? = UserDefaultsRunningStateStore()) {
        self.clock = clock
        self.store = store
        // Attempt to restore any running state
        if let restored = store?.loadCurrentEntry() {
            self.currentEntry = restored
        }
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
        store?.save(currentEntry: currentEntry)
    }

    func stop() {
        guard var running = currentEntry else { return }
        let now = clock.now()
        running.endAt = now
        // Accidental-tap guard: discard if duration < minimum
        if let endAt = running.endAt, endAt.timeIntervalSince(running.startAt) >= minimumDuration {
            _ = insert(running)
        }
        currentEntry = nil
        store?.save(currentEntry: currentEntry)
    }

    // Zero-gap auto-switching: close current and start new at identical timestamp
    func switchTo(activityId: UUID) {
        let now = clock.now()
        if var running = currentEntry {
            running.endAt = now
            // Apply accidental-tap guard
            if let endAt = running.endAt, endAt.timeIntervalSince(running.startAt) >= minimumDuration {
                _ = insert(running)
            }
        }
        currentEntry = Entry(activityId: activityId, startAt: now, endAt: nil)
        store?.save(currentEntry: currentEntry)
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

    // Persist current running state explicitly (e.g., on app background)
    func persist() {
        store?.save(currentEntry: currentEntry)
    }

    // MARK: - Non-overlap enforcement and insertion API

    // Inserts a completed entry if and only if it does not overlap the last saved entry.
    // Allows boundary equality: previous.endAt == new.startAt is valid.
    @discardableResult
    func insert(_ entry: Entry) -> Bool {
        guard entry.endAt != nil else { return false }
        if let last = entries.last {
            if let lastEnd = last.endAt {
                // Reject if new starts before last ended (strictly less than)
                if entry.startAt < lastEnd { return false }
            }
        }
        entries.append(entry)
        return true
    }
}
