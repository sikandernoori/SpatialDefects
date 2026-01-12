//
//  ReviewView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI

struct ReviewView: View {

    @EnvironmentObject private var state: AppState

    @State private var showSnackbar = false
    @State private var snackbarMessage = ""
    @State private var snackbarIsError = false

    var body: some View {
        NavigationStack {
            ZStack {
                List {

                    // MARK: - DEFECTS
                    Section("Defects (\(state.defects.count))") {
                        if state.defects.isEmpty {
                            Text("No defects captured yet.")
                        } else {
                            ForEach(state.defects) { defect in
                                NavigationLink {
                                    DefectDetailView(defect: defect)
                                } label: {
                                    HStack(spacing: 12) {
                                        if let img = ImageStore.loadImage(filename: defect.imageFilename) {
                                            Image(uiImage: img)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 72, height: 72)
                                                .clipped()
                                                .cornerRadius(8)
                                        } else {
                                            Color.gray
                                                .frame(width: 72, height: 72)
                                                .cornerRadius(8)
                                        }

                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(defect.note)
                                                .font(.headline)

                                            Text(defect.createdAt.formatted(
                                                date: .abbreviated,
                                                time: .shortened
                                            ))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                            .onDelete { idx in
                                state.defects.remove(atOffsets: idx)
                            }
                        }
                    }

                    // MARK: - GEOMETRY
                    Section("3D Geometry") {

                        if state.capturedRoom != nil {
                            NavigationLink("Apple 3D Preview") {
                                AppleUSDZPreviewView(capturedRoom: state.capturedRoom!)
                            }

                            NavigationLink("Custom 3D Room View") {
                                Room3DViewerScreen()
                            }
                        }

                        Button(state.capturedRoom == nil
                               ? "Capture Geometry"
                               : "Re-capture Geometry") {
                            state.flow = .captureGeometry
                        }
                    }

                    // MARK: - ACTIONS
                    Section("Actions") {
                        Button("Back to Defect Scan") {
                            state.flow = .scanDefects
                        }

                        Button("Reset Everything", role: .destructive) {
                            state.resetAll()
                        }
                    }
                    
                    Section {
                        Button("Submit") {
                            handleSubmit()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                // MARK: - SUBMIT
                

                // MARK: - SNACKBAR
                if showSnackbar {
                    VStack {
                        Spacer()
                        SnackbarView(
                            message: snackbarMessage,
                            isError: snackbarIsError
                        )
                    }
                }
            }
            .navigationTitle("Review")
        }
    }

    // MARK: - Submit Logic
    private func handleSubmit() {

        if state.defects.isEmpty && state.capturedRoom == nil {
            showMessage(
                "Please capture defects and room geometry before submitting.",
                isError: true
            )
            return
        }

        if state.defects.isEmpty {
            showMessage(
                "Please capture at least one defect before submitting.",
                isError: true
            )
            return
        }

        if state.capturedRoom == nil {
            showMessage(
                "Please capture room geometry before submitting.",
                isError: true
            )
            return
        }

        showMessage(
            "Defects successfully submitted.",
            isError: false
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            state.resetAll()
        }
    }

    private func showMessage(_ message: String, isError: Bool) {
        snackbarMessage = message
        snackbarIsError = isError

        withAnimation {
            showSnackbar = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                showSnackbar = false
            }
        }
    }
}
