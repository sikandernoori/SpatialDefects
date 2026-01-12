//
//  Defect.swift
//  SpatialDefects
//
//  Created by Skandar Munir Ahmed on 12.01.2026.
//


import Foundation
import simd

struct Defect: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    let worldTransform: simd_float4x4
    let imageFilename: String
    let note: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case worldTransform
        case imageFilename
        case note
    }

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        worldTransform: simd_float4x4,
        imageFilename: String,
        note: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.worldTransform = worldTransform
        self.imageFilename = imageFilename
        self.note = note
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        imageFilename = try container.decode(String.self, forKey: .imageFilename)
        note = try container.decode(String.self, forKey: .note)

        let matrixArray = try container.decode([Float].self, forKey: .worldTransform)
        worldTransform = simd_float4x4(array: matrixArray)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(imageFilename, forKey: .imageFilename)
        try container.encode(note, forKey: .note)
        try container.encode(worldTransform.array, forKey: .worldTransform)
    }
}


struct DefectDraft {
    let worldTransform: simd_float4x4
    let imageFilename: String
}

extension simd_float4x4 {
    var array: [Float] {
        [
            columns.0.x, columns.0.y, columns.0.z, columns.0.w,
            columns.1.x, columns.1.y, columns.1.z, columns.1.w,
            columns.2.x, columns.2.y, columns.2.z, columns.2.w,
            columns.3.x, columns.3.y, columns.3.z, columns.3.w
        ]
    }

    init(array: [Float]) {
        precondition(array.count == 16)
        self.init(columns: (
            SIMD4(array[0],  array[1],  array[2],  array[3]),
            SIMD4(array[4],  array[5],  array[6],  array[7]),
            SIMD4(array[8],  array[9],  array[10], array[11]),
            SIMD4(array[12], array[13], array[14], array[15])
        ))
    }
}

