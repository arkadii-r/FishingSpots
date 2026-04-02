//
//  ErrorView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 03.04.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let somethingWentWrong = "Something went wrong"
    }
    
    struct Button {
        static let tryAgain = "Try again"
    }
}

struct ErrorView: View {
    let errorText: String?
    let retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(.error)
            
            Text(errorText ?? Constant.Text.somethingWentWrong)
                .font(AppTheme.Fonts.header2Bold)
                .foregroundColor(AppTheme.Colors.adaptiveBlack)
            
            Spacer()
            
            Button(Constant.Button.tryAgain) {
                retryAction()
            }
        }
        .background(AppTheme.Colors.adaptiveWhite)
    }
}

#Preview {
    ErrorView(errorText: "Error", retryAction: { })
}
