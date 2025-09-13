//
//  ContentView.swift
//  ActivityLog
//
//  Created by Sergio Padron on 13/09/2025.
//

import SwiftUI
import Combine

struct DemoActivity: Identifiable, Hashable {
    let id: UUID
    let name: String
}

final class ActivitiesViewModel: ObservableObject {
    @Published var activities: [DemoActivity] = [
        DemoActivity(id: UUID(), name: "Coding"),
        DemoActivity(id: UUID(), name: "Meetings"),
        DemoActivity(id: UUID(), name: "Review")
    ]
    @Published var controller = ActivityTimerController()
}

struct ContentView: View {
    @StateObject private var vm = ActivitiesViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activities")
                .font(.title)
                .bold()

            HStack(spacing: 12) {
                ForEach(vm.activities) { activity in
                    ActivityTile(activity: activity, isRunning: vm.controller.isRunning(activityId: activity.id)) {
                        vm.controller.tap(activityId: activity.id)
                    }
                }
            }

            if let current = vm.controller.currentEntry,
               let name = vm.activities.first(where: { $0.id == current.activityId })?.name {
                Text("Running: \(name)")
                    .foregroundStyle(.green)
            } else {
                Text("Idle")
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct ActivityTile: View {
    let activity: DemoActivity
    let isRunning: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack {
                Text(activity.name)
                    .font(.headline)
                    .foregroundStyle(isRunning ? .white : .primary)
                    .padding(12)
                    .frame(width: 110, height: 60)
                    .background(isRunning ? Color.green : Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(isRunning ? "Stop \(activity.name)" : "Start \(activity.name)"))
    }
}
