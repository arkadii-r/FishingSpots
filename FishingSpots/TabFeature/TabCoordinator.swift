//
//  TabCoordinator.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 02.04.2026.
//

import Foundation
import Observation

@Observable
final class TabCoordinator {
    enum Tabs {
        case list
        case map
        case weather
        case settings
    }
    
    var selection: Tabs = .list
}
