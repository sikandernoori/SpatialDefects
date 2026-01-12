//
//  RoomPlanCaptureContainer.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI

struct RoomPlanCaptureContainer: UIViewControllerRepresentable {

    @EnvironmentObject private var state: AppState
    @Binding var controller: RoomPlanCaptureViewController?

    func makeUIViewController(context: Context) -> RoomPlanCaptureViewController {
        let vc = RoomPlanCaptureViewController()

        vc.onFinished = { room in
            Task { @MainActor in
                state.capturedRoom = room
                state.flow = .review
            }
        }

        vc.onCancelled = {
            Task { @MainActor in
                state.flow = .scanDefects
            }
        }

        DispatchQueue.main.async {
            controller = vc
        }

        return vc
    }

    func updateUIViewController(_ uiViewController: RoomPlanCaptureViewController, context: Context) {}
}
