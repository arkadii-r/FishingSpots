//
//  Icon.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 30.03.2026.
//

import Foundation
import SwiftUI

enum Icon: String, CaseIterable, Identifiable {
    case primary    = "AppIcon"
    case blue       = "AppIcon-Blue"
    case dark = "AppIcon-Dark"
    
    var id: String { self.rawValue }

    var iconImageResource: ImageResource {
        switch self {
        case .primary:
            return .appIconGreen
            
        case .blue:
            return .appIconBlue

        case .dark:
            return .appIconDark
        }
    }
}
