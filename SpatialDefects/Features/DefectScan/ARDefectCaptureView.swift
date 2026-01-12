//
//  ARDefectCaptureView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import SwiftUI
import RealityKit
import ARKit
import UIKit

struct ARDefectCaptureView: UIViewRepresentable {

    @EnvironmentObject private var state: AppState

    func makeCoordinator() -> Coordinator {
        let coord = Coordinator(state: state)
        state.arCoordinator = coord
        return coord
    }

    func makeUIView(context: Context) -> UIView {

        let container = UIView()
        container.backgroundColor = .clear

        let arView = ARView(frame: .zero)
        arView.translatesAutoresizingMaskIntoConstraints = false
        arView.automaticallyConfigureSession = false

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)

        container.addSubview(arView)

        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: container.topAnchor),
            arView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            arView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        let drawingView = DrawingView()
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.isOpaque = false
        drawingView.backgroundColor = .clear

        container.addSubview(drawingView)

        NSLayoutConstraint.activate([
            drawingView.topAnchor.constraint(equalTo: container.topAnchor),
            drawingView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            drawingView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            drawingView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])

        context.coordinator.arView = arView
        context.coordinator.drawingView = drawingView

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    // MARK: - Coordinator
    final class Coordinator: NSObject {

        weak var arView: ARView?
        weak var drawingView: DrawingView?
        private let state: AppState

        init(state: AppState) {
            self.state = state
        }

        func saveDefect() {
            guard
                let arView,
                let drawingView,
                let frame = arView.session.currentFrame,
                drawingView.points.count > 3
            else { return }

            let center = drawingView.points.average
            guard let hit = arView.raycast(
                from: center,
                allowing: .estimatedPlane,
                alignment: .any
            ).first else { return }

            let image = frame.capturedImage.toUIImage(orientation: .right)

            let annotated = image.drawPathAspectFillCorrected(
                normalizedViewPoints: drawingView.normalizedPoints,
                viewSize: drawingView.bounds.size
            )

            do {
                let filename = try ImageStore.saveJPEG(annotated)

                Task { @MainActor in
                    state.pendingDefectDraft = DefectDraft(
                        worldTransform: hit.worldTransform,
                        imageFilename: filename
                    )
                    state.isPresentingDefectEditor = true
                }

                drawingView.reset()
            } catch {
                print("Save failed:", error)
            }
        }
    }
}

// MARK: - Drawing View
final class DrawingView: UIView {

    var points: [CGPoint] = []

    var normalizedPoints: [CGPoint] {
        guard bounds.width > 0, bounds.height > 0 else { return [] }
        return points.map {
            CGPoint(x: $0.x / bounds.width, y: $0.y / bounds.height)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError() }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return }
        points = [p]
        setNeedsDisplay()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return }
        points.append(p)
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard points.count > 1 else { return }
        let path = UIBezierPath()
        path.move(to: points[0])
        for p in points.dropFirst() { path.addLine(to: p) }
        path.lineWidth = 6
        UIColor.red.setStroke()
        path.stroke()
    }

    func reset() {
        points.removeAll()
        setNeedsDisplay()
    }
}

// MARK: - IMAGE FIX (ASPECT FILL CORRECTION)
extension UIImage {

    func drawPathAspectFillCorrected(
        normalizedViewPoints: [CGPoint],
        viewSize: CGSize
    ) -> UIImage {

        let imageAspect = size.width / size.height
        let viewAspect = viewSize.width / viewSize.height

        var scale: CGFloat
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0

        if imageAspect > viewAspect {
            scale = size.height / viewSize.height
            let scaledWidth = viewSize.width * scale
            xOffset = (size.width - scaledWidth) / 2
        } else {
            scale = size.width / viewSize.width
            let scaledHeight = viewSize.height * scale
            yOffset = (size.height - scaledHeight) / 2
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero)

        let ctx = UIGraphicsGetCurrentContext()!
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.setLineWidth(6)
        ctx.setLineCap(.round)

        if let first = normalizedViewPoints.first {
            ctx.move(
                to: CGPoint(
                    x: first.x * viewSize.width * scale + xOffset,
                    y: first.y * viewSize.height * scale + yOffset
                )
            )

            for p in normalizedViewPoints.dropFirst() {
                ctx.addLine(
                    to: CGPoint(
                        x: p.x * viewSize.width * scale + xOffset,
                        y: p.y * viewSize.height * scale + yOffset
                    )
                )
            }
            ctx.strokePath()
        }

        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}

// MARK: - Helpers
extension CVPixelBuffer {
    func toUIImage(orientation: UIImage.Orientation) -> UIImage {
        let ci = CIImage(cvPixelBuffer: self)
        let ctx = CIContext()
        let cg = ctx.createCGImage(ci, from: ci.extent)!
        return UIImage(cgImage: cg, scale: 1, orientation: orientation)
    }
}

extension Array where Element == CGPoint {
    var average: CGPoint {
        reduce(.zero) {
            CGPoint(x: $0.x + $1.x / CGFloat(count),
                    y: $0.y + $1.y / CGFloat(count))
        }
    }
}
