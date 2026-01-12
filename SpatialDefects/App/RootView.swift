//
//  RootView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject private var state: AppState

    var body: some View {
        switch state.flow {
        case .intro:
            IntroView()

        case .scanDefects:
            DefectScanView()

        case .captureGeometry:
            RoomPlanGeometryCaptureView()

        case .review:
            ReviewView()
        }
    }
}
