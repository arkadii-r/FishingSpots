//
//  FishingSpot.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation

struct FishingSpot: Identifiable {
    let name: String
    let location: String
    let latitude: Double
    let longitude: Double
    let catches: [CatchReport]
    
    let id: String = UUID().uuidString
    
    var catchCount: String {
        String(catches.reduce(0) { $0 + $1.count })
    }
}
