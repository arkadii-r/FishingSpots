//
//  FishingSpot.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation

struct FishingSpot: Identifiable, Equatable {
    var name: String
    var location: String
    let latitude: Double
    let longitude: Double
    let catchReports: [CatchReport]
    
    let id: String = UUID().uuidString
    
    var coordinatesString: String {
        "\(latitude), \(longitude)"
    }
    
    var catchCount: String {
        String(catchReports.reduce(0) { $0 + $1.count })
    }
    
    init(
        name: String,
        location: String,
        latitude: Double,
        longitude: Double,
        catchReports: [CatchReport]
    ) {
        self.name = name
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.catchReports = catchReports
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
    }
}
