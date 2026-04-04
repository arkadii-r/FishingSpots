//
//  FishingSpot.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation
import CoreLocation

struct FishingSpot: Identifiable, Equatable {
    let id: String
    var name: String
    var location: String
    let coordinate: CLLocationCoordinate2D
    var catchReports: [CatchReport]
    let createdAt: Date
    
    var coordinatesString: String {
        "\(String(format: "%.6f", coordinate.latitude)), \(String(format: "%.6f", coordinate.longitude))"
    }
    
    var catchCount: String {
        String(catchReports.reduce(0) { $0 + $1.count })
    }
    
    init(
        id: String,
        name: String,
        location: String,
        coordinate: CLLocationCoordinate2D,
        catchReports: [CatchReport],
        createdAt: Date
    ) {
        self.id = id
        self.name = name
        self.location = location
        self.coordinate = coordinate
        self.catchReports = catchReports
        self.createdAt = createdAt
    }
    
    init(
        location: String,
        coordinate: CLLocationCoordinate2D
    ) {
        self.id = ""
        self.name = ""
        self.location = location
        self.coordinate = coordinate
        self.catchReports = []
        self.createdAt = Date.now
    }
}
