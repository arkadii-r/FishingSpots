//
//  FishingSpot.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation
import FirebaseFirestore

struct FishingSpot: Identifiable, Equatable, Codable {
    @DocumentID var id: String?
    var name: String
    var location: String
    let latitude: Double
    let longitude: Double
    let catchReports: [CatchReport]
    let createdAt: Date
    
    var coordinatesString: String {
        "\(String(format: "%.6f", latitude)), \(String(format: "%.6f", longitude))"
    }
    
    var catchCount: String {
        String(catchReports.reduce(0) { $0 + $1.count })
    }
    
    init(
        name: String,
        location: String,
        latitude: Double,
        longitude: Double,
        catchReports: [CatchReport],
        createdAt: Date
    ) {
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.catchReports = catchReports
        self.createdAt = createdAt
    }
    
    init(
        location: String,
        latitude: Double,
        longitude: Double
    ) {
        self.name = ""
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.catchReports = []
        self.createdAt = Date.now
    }
}
