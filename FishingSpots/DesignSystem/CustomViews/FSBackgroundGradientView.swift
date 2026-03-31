//
//  FSBackgroundGradientView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import Foundation
import SwiftUI

struct FSBackgroundGradientView: View {
    var body: some View {
        LinearGradient(
            stops: [
                .init(color: AppTheme.Colors.fsPrimaryGreen, location: 0.45),
                .init(color: AppTheme.Colors.fsSecondaryGreen, location: 0.95)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
