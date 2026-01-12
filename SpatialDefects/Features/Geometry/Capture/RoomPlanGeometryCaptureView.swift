//
//  RoomPlanGeometryCaptureView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI

struct RoomPlanGeometryCaptureView: View {

    @EnvironmentObject private var state: AppState
    @State private var controller: RoomPlanCaptureViewController?

    var body: some View {
        NavigationStack {
            RoomPlanCaptureContainer(controller: $controller)
                .navigationTitle("Capture Geometry")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {

                    // CANCEL
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            controller?.cancelScanning()
                            state.flow = .scanDefects
                        }
                    }

                    // DONE
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            controller?.stopScanning()
                        }
                    }
                }
        }
    }
}
