//
//  SpotDetailViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import Foundation
import Observation
import UIKit

@Observable
final class SpotDetailViewModel {
    let spot: FishingSpot
    
    init(spot: FishingSpot) {
        self.spot = spot
    }
    
    func copyCoordinates() {
        UIPasteboard.general.string = spot.coordinatesString
    }
    
}
