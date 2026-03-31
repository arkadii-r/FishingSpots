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
    var spots: [FishingSpot] = [.init(name: "Ladoga", location: "Ladoga lake", latitude: 30.1232, longitude: 40.3242, catches: [.init(fish: "pike", count: 1, photo: nil, date: ""), .init(fish: "pidske", count: 3, photo: nil, date: "")]),
                                .init(name: "Vuoksa", location: "Vuoksa lake", latitude: 30.1232, longitude: 40.3242, catches: []),
                                .init(name: "Vyborg", location: "Vyborg lake", latitude: 30.1232, longitude: 40.3242, catches: [])
    ]
    var spotDetail: FishingSpot?
}
