//
//  IntroView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//


import SwiftUI

struct IntroView: View {

    @EnvironmentObject private var state: AppState

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.orange)

            Text("Defect Scan")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("""
                    Please walk through the room and mark visible defects
                    such as cracks, stains, or damage.

                    Each defect will be saved with:
                    • A photo
                    • A short description
                    • Its position in space
            """)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 32)

            Spacer()

            Button {
                state.flow = .scanDefects
            } label: {
                Text("Start Defect Scanning")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}
