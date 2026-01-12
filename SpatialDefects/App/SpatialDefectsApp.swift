//
//  SpatialDefectsApp.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI

@main
struct SpatialDefectsApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
        }
    }
}
