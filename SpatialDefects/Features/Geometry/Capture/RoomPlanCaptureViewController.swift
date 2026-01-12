//
//  RoomPlanCaptureViewController.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//

import UIKit
import RoomPlan

final class RoomPlanCaptureViewController: UIViewController {

    var onFinished: ((CapturedRoom) -> Void)?
    var onCancelled: (() -> Void)?

    private var roomCaptureView: RoomCaptureView!
    private let configuration = RoomCaptureSession.Configuration()
    private var isStopping = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        roomCaptureView = RoomCaptureView(frame: view.bounds)
        roomCaptureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        roomCaptureView.delegate = self
        roomCaptureView.captureSession.delegate = self
        view.addSubview(roomCaptureView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        roomCaptureView.captureSession.run(configuration: configuration)
    }

    // MARK: - CALLED FROM SWIFTUI

    func stopScanning() {
        guard !isStopping else { return }
        isStopping = true
        roomCaptureView.captureSession.stop()
    }

    func cancelScanning() {
        roomCaptureView.captureSession.stop()
        onCancelled?()
    }
}

// MARK: - Delegates
extension RoomPlanCaptureViewController: RoomCaptureViewDelegate, RoomCaptureSessionDelegate {

    func captureView(
        shouldPresent roomDataForProcessing: CapturedRoomData,
        error: Error?
    ) -> Bool {
        true
    }

    func captureView(
        didPresent processedResult: CapturedRoom,
        error: Error?
    ) {
        onFinished?(processedResult)
    }
}
