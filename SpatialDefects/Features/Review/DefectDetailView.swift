//
//  DefectDetailView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//


import SwiftUI

struct DefectDetailView: View {

    let defect: Defect
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            if let image = ImageStore.loadImage(filename: defect.imageFilename) {
                GeometryReader { geo in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height
                        )
                        .background(Color.black)
                }
            } else {
                Color.black
            }
            VStack(alignment: .leading, spacing: 12) {
                Text("Defect Description")
                    .font(.headline)

                Text(defect.note)
                    .font(.body)

                Text(defect.createdAt.formatted(
                    date: .abbreviated,
                    time: .shortened
                ))
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
    }
}
