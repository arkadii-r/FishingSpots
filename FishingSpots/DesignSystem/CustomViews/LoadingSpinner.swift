//
//  LoadingSpinner.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 24.03.2026.
//

import Foundation
import SwiftUI

struct LoadingSpinner: View {
    @State private var isAnimating = false
    private let color: Color
    private let width: CGFloat
    private let height: CGFloat
    private let lineWidth: CGFloat
    
    init(
        color: Color = AppTheme.Colors.fsPrimaryGreen,
        width: CGFloat = 36,
        height: CGFloat = 36,
        lineWidth: CGFloat = 5
    ) {
        self.color = color
        self.width = width
        self.height = height
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(color, lineWidth: lineWidth)
            .frame(width: width, height: height)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    self.isAnimating = true
                }
            }
    }
}

struct LoadingSpinner_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinner()
    }
}
