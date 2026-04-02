//
//  AddSpotViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 01.04.2026.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
final class AddSpotViewModel {
    @ObservationIgnored
    @Injected(\.spotsRepository) var spotsRepository
    
    var newSpot: FishingSpot
    var isLoadingAddButton: Bool = false
    var addingErrorText: String?
    
    var addButtonEnabled: Bool {
        !newSpot.name.isEmpty
    }
        
    init(
        newSpot: FishingSpot
    ) {
        self.newSpot = newSpot
    }
    
    func addSpot() {
        addingErrorText = nil
        isLoadingAddButton = true
        Task {
            do {
                try await spotsRepository.addSpot(newSpot)
                isLoadingAddButton = false
            } catch {
                isLoadingAddButton = false
                addingErrorText = error.localizedDescription
            }
        }
    }
}
