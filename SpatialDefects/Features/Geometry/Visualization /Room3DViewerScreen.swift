//
//  Room3DViewerScreen.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//


import SwiftUI
import RoomPlan

struct Room3DViewerScreen: View {

    @EnvironmentObject private var state: AppState

    var body: some View {
        if let room = state.capturedRoom {
            SceneKitRoomView(capturedRoom: room)
                .ignoresSafeArea()
                .navigationTitle("3D Room")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("No room captured.")
        }
    }
}
