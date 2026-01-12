//
//  SceneKitRoomView.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//


import SwiftUI
import SceneKit
import RoomPlan

struct SceneKitRoomView: UIViewRepresentable {

    let capturedRoom: CapturedRoom

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.backgroundColor = .black

        let scene = SCNScene()
        view.scene = scene

        let root = SCNNode()
        scene.rootNode.addChildNode(root)

        if #available(iOS 17.0, *) {
            add(surfaces: capturedRoom.floors, color: .darkGray, to: root, thickness: 0.02)
        }
        add(surfaces: capturedRoom.walls, color: .lightGray, to: root, thickness: 0.08)
        add(surfaces: capturedRoom.doors, color: .brown, to: root, thickness: 0.06)
        add(surfaces: capturedRoom.windows, color: UIColor.cyan.withAlphaComponent(0.25), to: root, thickness: 0.04)

        addCamera(to: scene, target: root)

        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}

    private func add(
        surfaces: [CapturedRoom.Surface],
        color: UIColor,
        to parent: SCNNode,
        thickness: CGFloat
    ) {
        for s in surfaces {
            let dims = s.dimensions

            let box = SCNBox(
                width: max(CGFloat(dims.x), 0.01),
                height: max(CGFloat(dims.y), 0.01),
                length: thickness,
                chamferRadius: 0
            )

            let material = SCNMaterial()
            material.diffuse.contents = color
            material.lightingModel = .physicallyBased
            box.materials = [material]

            let node = SCNNode(geometry: box)
            node.simdTransform = s.transform
            parent.addChildNode(node)
        }
    }

    private func addCamera(to scene: SCNScene, target: SCNNode) {
        let camera = SCNCamera()
        camera.zNear = 0.01
        camera.zFar = 1000

        let camNode = SCNNode()
        camNode.camera = camera
        camNode.position = SCNVector3(3, 3, 3)

        let lookAt = SCNLookAtConstraint(target: target)
        lookAt.isGimbalLockEnabled = true
        camNode.constraints = [lookAt]

        scene.rootNode.addChildNode(camNode)
    }
}
