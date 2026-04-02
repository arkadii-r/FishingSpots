//
//  SpotListViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation
import Observation

@Observable
final class SpotListViewModel {
    private var spots: [FishingSpot] = [
        .init(
            name: "Salt Lake",
            location: "Salt Lake City, USA",
            latitude: 30.1232,
            longitude: 40.3242,
            catchReports: [
                .init(
                    fish: "Pike",
                    weight: 3.14,
                    count: 1,
                    photoURL: nil,
                    date: ""
                ),
                .init(
                    fish: "Bass",
                    weight: 4.71,
                    count: 3,
                    photoURL: nil,
                    date: ""
                )
            ]
        ),
        .init(
            name: "Vuoksa",
            location: "Vuoksa River, Finland",
            latitude: 30.1232,
            longitude: 40.3242,
            catchReports: []
        ),
        .init(
            name: "Sevan",
            location: "Sevan, Armenia",
            latitude: 30.1232,
            longitude: 40.3242,
            catchReports: []
        )
    ]
    
    var searchText: String = ""
    
    var filteredSpots: [FishingSpot] {
        searchText.isEmpty ? spots : spots.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var spotDetail: FishingSpot?
    
    func deleteSpot(_ spot: FishingSpot) {
        spots.removeAll { $0.id == spot.id }
    }
}
