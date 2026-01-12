//
//  SnackbarView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//


import SwiftUI

struct SnackbarView: View {

    let message: String
    let isError: Bool

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(isError ? Color.red : Color.green)
            .cornerRadius(10)
            .padding(.bottom, 24)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
