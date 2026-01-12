//
//  DefectScanView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI

struct DefectScanView: View {

    @EnvironmentObject private var state: AppState
    @State private var coordinator: ARDefectCaptureView.Coordinator?

    var body: some View {
        ARDefectCaptureView()
            .environmentObject(state)
            .ignoresSafeArea()
            .overlay {
                Color.clear.onAppear {
                    // Capture coordinator once view is mounted
                    coordinator = state.arCoordinator
                }
            }
            .safeAreaInset(edge: .top) {
                HStack {
                    Button("Save Defect") {
                        state.arCoordinator?.saveDefect()
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()

                    Button("Review") {
                        state.flow = .review
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Button("Capture Geometry") {
                        state.flow = .captureGeometry
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("Reset", role: .destructive) {
                        state.resetAll()
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .sheet(isPresented: $state.isPresentingDefectEditor) {
                DefectEditorSheet()
            }
    }
}
