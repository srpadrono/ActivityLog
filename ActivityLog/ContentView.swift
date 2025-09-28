//
//  ContentView.swift
//  ActivityLog
//
//  Created by Sergio Padron on 13/09/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodayView.PreviewViewModel()

    var body: some View {
        NavigationStack {
            TodayView(viewModel: viewModel)
        }
    }
}
