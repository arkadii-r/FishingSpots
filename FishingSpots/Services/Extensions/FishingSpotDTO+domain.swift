//
//  FishingSpotDTO+domain.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 05.04.2026.
//

import Foundation
import CoreLocation

extension FishingSpotDTO {
    var domainModel: FishingSpot? {
        guard let id else { return nil }
        
        return .init(
            id: id,
            name: name,
            location: location,
            coordinate: .init(latitude: latitude, longitude: longitude),
            catchReports: catchReports.map(\.domainModel),
            createdAt: createdAt
        )
    }
}
