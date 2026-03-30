//
//  FSButtonStyle.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 24.03.2026.
//

import Foundation
import SwiftUI

enum FSButtonStyle {
    case primary
    case secondary
}

enum FSButtonSize {
    case medium
    case small
}


struct FSButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    let style: FSButtonStyle
    let size: FSButtonSize
    
    let isLoading: Bool
    
    var height: CGFloat {
        switch size {
        case .medium:
            return 52
            
        case .small:
            return 44
        }
    }
    
    var foregroundColor: Color {
        switch style {
        case .primary:
            return AppTheme.Colors.white
            
        case .secondary:
            return AppTheme.Colors.black
        }
    }
    
    var backgroundColor: Color {
        switch style {
        case .primary:
            return AppTheme.Colors.fsPrimaryGreen
            
        case .secondary:
            return AppTheme.Colors.disabledGray
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .isHidden(isLoading)
            .padding(.horizontal)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .background(backgroundColor.opacity(isEnabled ? 1 : 0.5))
            .opacity(configuration.isPressed ? 0.7 : 1)
            .cornerRadius(16)
            .foregroundColor(foregroundColor.opacity(isEnabled ? 1 : 0.7))
            .font(AppTheme.Fonts.bodyBold)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .allowsHitTesting(!isLoading)
            .overlay {
                if isLoading {
                    ButtonSpinner(buttonStyle: style)
                }
            }
        
    }
}

extension ButtonStyle where Self == FSButton {
    static func fsButton(_ style: FSButtonStyle, size: FSButtonSize = .medium, isLoading: Bool = false) -> Self {
        Self(
            style: style,
            size: size,
            isLoading: isLoading
        )
    }
}
