# SpatialDefects – XR Defect Capture Prototype

## Overview
This prototype is to demonstrate a realistic **room inspection workflow** using iOS `ARKIT` and `RoomPlan`.

The flow is:
- Scan defects (mandatory)
- Capture room geometry (mandatory)
- Review everything together (redo defect or room geometry if needed)
- Submit the inspection

Submission is **blocked unless both defects and geometry are captured**.

---

## Repository
`https://github.com/sikandernoori/SpatialDefects.git`

---

## Platform & Stack
- Platform: **iOS**
- Device tested: **iPhone 15 Pro Max**
- OS: **iOS 17.x**
- Language: **Swift 5.x**
- Project format: Xcode 16.0
- UI: **SwiftUI** (UIKit where required)
- XR / 3D:
  - ARKit
  - RealityKit
  - RoomPlan
  - SceneKit
- Build tools: **XCode Version 26.2 (17C52)**
- No third-party libraries

---

## App Flow
- **Intro**
  - Start a new inspection

- **Defect Scan**
  - Live AR camera view
  - User draws directly on the screen to highlight a defect
  - App captures:
    - still image
    - highlighted defect area
    - short description
    - ARKit world transform (approximate spatial anchor)

- **Geometry Capture**
  - RoomPlan scan with Done / Cancel
  - Generates parametric room geometry
  - Geometry can be re-captured

- **Review**
  - List of defects
  - Full-screen defect detail view
  - Apple USDZ preview
  - Custom 3D room viewer using scene kit

- **Submit**
  - Requires:
    - at least one defect
    - geometry captured
  - Shows confirmation message
  - Returns to start screen

---

## Setup Instructions
- Requires **XCode Version 26.2 (17C52)**
- Requires **physical LiDAR-enabled iPhone with IOS 17.x minimum** (simulator not supported)

Steps:
1. Clone the repository
2. Open `SpatialDefects.xcodeproj`
3. Select a physical iPhone
4. Enable automatic signing
5. Build & run
6. Allow camera permissions

---

## Assumptions & Limitations
- Single-room inspections only
- Defects are anchored using **ARKit raycasting**
- Defects are **not semantically bound** to RoomPlan wall/floor IDs
- Geometry provides **context**, not survey-grade accuracy
- No persistence across launches
- No backend submission (local validation only)

---

## Notes
I have intentional;y removed Hit testing to high light defect during defect detection view because just a marker is not sufficient for delivering business logic of defect highlighting.
RoomPlan does not allow interactive surface hit-testing during capture as by design from Apple.
For that reason, the **annotated defect image is treated as the primary evidence**, with geometry used for spatial context like length, width, and depth.

if Hittest is indeed needed that can easily be achieved by adding below code in file `ARDefectCaptureView.swift`:

```

let tap = UITapGestureRecognizer(
    target: context.coordinator,
    action: #selector(Coordinator.handleTap(_:))
)
container.addGestureRecognizer(tap)
```


```
@objc func handleTap(_ gesture: UITapGestureRecognizer) {
    guard
        let arView,
        let frame = arView.session.currentFrame
    else { return }

    let location = gesture.location(in: arView)

    guard let hit = arView.raycast(
        from: location,
        allowing: .estimatedPlane,
        alignment: .any
    ).first else { return }

    let image = frame.capturedImage.toUIImage(orientation: .right)

    // Optional: draw a small marker at tap location
    let annotated = image.drawCircle(
        normalizedPoint: CGPoint(
            x: location.x / arView.bounds.width,
            y: location.y / arView.bounds.height
        )
    )
}
```