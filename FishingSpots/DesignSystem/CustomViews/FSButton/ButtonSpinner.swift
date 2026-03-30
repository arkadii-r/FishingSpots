//
//  ButtonSpinner.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 24.03.2026.
//

import Foundation
import SwiftUI

struct ButtonSpinner: View {
    @State private var isAnimating = false
    let buttonStyle: FSButtonStyle
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(buttonStyle == .primary ? AppTheme.Colors.white : AppTheme.Colors.gray, lineWidth: 3).opacity(0.4)
                .frame(width: 20, height: 20)
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(buttonStyle == .primary ? AppTheme.Colors.white : AppTheme.Colors.fsPrimaryGreen, lineWidth: 3)
                .frame(width: 20, height: 20)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false), value: isAnimating)
                .onAppear {
                    withAnimation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                        self.isAnimating = true
                    }
                }
        }
    }
}
