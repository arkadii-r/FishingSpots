//
//  LoadingView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 03.04.2026.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            
            LoadingSpinner()
            
            Spacer()
        }
        .background(AppTheme.Colors.adaptiveWhite)
    }
}

#Preview {
    LoadingView()
}
