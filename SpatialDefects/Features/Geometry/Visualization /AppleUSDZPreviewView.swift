//
//  AppleUSDZPreviewView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI
import RoomPlan
import QuickLook

struct AppleUSDZPreviewView: View {

    let capturedRoom: CapturedRoom
    @State private var previewURL: URL?

    var body: some View {
        Group {
            if let previewURL {
                QLPreviewControllerRepresentable(url: previewURL)
            } else {
                ProgressView("Preparing 3D Preview…")
            }
        }
        .navigationTitle("Apple 3D Preview")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            do {
                previewURL = try capturedRoom.exportToTemporaryUSDZ()
            } catch {
                print("Export failed:", error)
            }
        }
    }
}

// MARK: - QuickLook wrapper
struct QLPreviewControllerRepresentable: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ vc: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        let url: URL

        init(url: URL) {
            self.url = url
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

        func previewController(
            _ controller: QLPreviewController,
            previewItemAt index: Int
        ) -> QLPreviewItem {
            url as NSURL
        }
    }
}

extension CapturedRoom {

    func exportToTemporaryUSDZ() throws -> URL {
        let tempDir = FileManager.default.temporaryDirectory
        let url = tempDir.appendingPathComponent("CapturedRoom-\(identifier).usdz")

        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }

        try export(to: url, exportOptions: .mesh)
        return url
    }
}
