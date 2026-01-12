//
//  AppState.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI
import Combine
import RoomPlan

@MainActor
final class AppState: ObservableObject {

    enum Flow {
        case intro
        case scanDefects
        case captureGeometry
        case review
    }

    @Published var flow: Flow = .intro

    @Published var defects: [Defect] = []
    @Published var capturedRoom: CapturedRoom? = nil

    @Published var isPresentingDefectEditor: Bool = false
    @Published var pendingDefectDraft: DefectDraft? = nil
    
    @Published var arCoordinator: ARDefectCaptureView.Coordinator?


    func resetAll() {
        defects.removeAll()
        capturedRoom = nil
        flow = .intro
    }

    func resetGeometryOnly() {
        capturedRoom = nil
        flow = .captureGeometry
    }
}
