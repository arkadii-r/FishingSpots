//
//  BlueGradientBackgroundView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 04.04.2026.
//

import Foundation
import SwiftUI


struct BlueGradientBackgroundView: ShapeStyle {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        LinearGradient(
            colors:[
                AppTheme.Colors.royalBlue,
                AppTheme.Colors.slateMidnight
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
