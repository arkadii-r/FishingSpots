//
//  AppView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 24.03.2026.
//

import Foundation
import SwiftUI

struct AppView: View {
    @State private var viewModel: AppViewModel = .init()
    
    var body: some View {
        VStack {
            switch viewModel.appState {
            case .login:
                EmptyView()
                
            case .main:
                MainTabView()
                
            case .loading:
                initialLoadingView
                
            case let .greeting(username):
                greetingView(username: username)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

private extension AppView {
    var initialLoadingView: some View {
        Image(.launchScreen)
            .resizable()
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                LoadingSpinner(color: AppTheme.Colors.white)
                    .padding(.bottom, 30)
            }
    }
    
    func greetingView(username: String) -> some View {
        Image(.greetingScreen)
            .resizable()
            .ignoresSafeArea()
            .overlay(alignment: .center) {
                Text("Welcome, \(username)!")
                    .font(AppTheme.Fonts.headerBold)
                    .foregroundColor(AppTheme.Colors.white)
                    .padding(.top, 25)
            }
    }
}

#Preview {
    AppView()
}
