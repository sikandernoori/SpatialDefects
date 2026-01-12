//
//  DefectEditorSheet.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//


import SwiftUI

struct DefectEditorSheet: View {

    @EnvironmentObject private var state: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Defect evidence") {
                    if let draft = state.pendingDefectDraft,
                       let img = ImageStore.loadImage(filename: draft.imageFilename) {
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 240)
                    } else {
                        Text("No image available.")
                    }
                }

                Section("Description") {
                    TextField("e.g. crack near window", text: $note)
                }
            }
            .navigationTitle("New Defect")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Discard") {
                        state.pendingDefectDraft = nil
                        state.isPresentingDefectEditor = false
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let draft = state.pendingDefectDraft else { return }
                        let defect = Defect(
                            id: UUID(),
                            createdAt: Date(),
                            worldTransform: draft.worldTransform,
                            imageFilename: draft.imageFilename,
                            note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Defect" : note
                        )
                        state.defects.append(defect)

                        state.pendingDefectDraft = nil
                        state.isPresentingDefectEditor = false
                        dismiss()
                    }
                }
            }
        }
    }
}
