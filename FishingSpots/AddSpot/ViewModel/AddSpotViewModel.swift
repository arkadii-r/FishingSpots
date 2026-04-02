//
//  AddSpotViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 01.04.2026.
//

import Foundation
import Observation

@Observable
final class AddSpotViewModel {
    var newSpot: FishingSpot
    var isLoadingAddButton: Bool = false
    
    var addButtonEnabled: Bool {
        !newSpot.name.isEmpty
    }
        
    init(
        newSpot: FishingSpot
    ) {
        self.newSpot = newSpot
    }
    
    func addSpot() {
        isLoadingAddButton = true
        isLoadingAddButton = false
    }
}
