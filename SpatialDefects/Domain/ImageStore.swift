//
//  ImageStore.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//


import Foundation
import UIKit

enum ImageStore {

    static func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func saveJPEG(_ image: UIImage, quality: CGFloat = 0.85) throws -> String {
        let filename = "defect-\(UUID().uuidString).jpg"
        let url = documentsDirectory().appendingPathComponent(filename)

        guard let data = image.jpegData(compressionQuality: quality) else {
            throw NSError(domain: "ImageStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode JPEG"])
        }
        try data.write(to: url, options: [.atomic])
        return filename
    }

    static func loadImage(filename: String) -> UIImage? {
        let url = documentsDirectory().appendingPathComponent(filename)
        return UIImage(contentsOfFile: url.path)
    }
}
