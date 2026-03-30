//
//  SettingsView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let yourUsername = "Your username:"
        static let yourEmail = "Your email:"
        static let appIcon = "App Icon"
    }
    
    struct Button {
        static let logout = "Logout"
    }
    
    static let navigationTitle = "Settings"
    static let logoutErrorAlert = "Logout failed"
}

struct SettingsView: View {
    @State var viewModel: SettingsViewModel = .init()
    
    var body: some View {
        contentView
            .padding(.top, 40)
            .padding([.bottom, .horizontal], 16)
            .navigationTitle(Constant.navigationTitle)
            .alert(isPresented: $viewModel.logoutAlertShown) {
                Alert(title: Text(viewModel.logoutErrorAlertText ?? Constant.logoutErrorAlert))
            }
    }
}

private extension SettingsView {
    var contentView: some View {
        VStack(alignment: .leading, spacing: 32) {
            if let username = viewModel.username {
                settingRowView(title: Constant.Text.yourUsername, value: username)
            }
            
            if let email = viewModel.userEmail {
                settingRowView(title: Constant.Text.yourEmail, value: email)
            }
            
            appIconPickerView
                .padding(.top, 24)
            
            Spacer()
            
            Button(Constant.Button.logout) {
                viewModel.signOut()
            }
            .buttonStyle(.fsButton(.secondary))
        }
    }
    func settingRowView(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(AppTheme.Fonts.callout)
                .foregroundColor(AppTheme.Colors.darkGray)

            Spacer()
            
            Text(value)
                .font(AppTheme.Fonts.calloutBold)
                .foregroundColor(AppTheme.Colors.adaptiveBlack)
        }
    }
    
    var appIconPickerView: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text(Constant.Text.appIcon)
                .font(AppTheme.Fonts.title3Bold)
            
            LazyVGrid(
                columns: .init(
                    repeating: GridItem(.flexible(minimum: 70, maximum: .infinity), spacing: 14),
                    count: 3
                ),
                spacing: 12
            ) {
                ForEach(Icon.allCases) { icon in
                    Image(icon.iconImageResource)
                        .tag(icon)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(
                                    .blue,
                                    lineWidth: viewModel.appIcon == icon ? 3 : 0
                                )
                        )
                        .onTapGesture {
                            viewModel.setAlternateAppIcon(icon: icon)
                        }
                }
            }
            .animation(.interactiveSpring, value: viewModel.appIcon)
            .padding()
            .background(AppTheme.Colors.backgroundGray)
            .cornerRadius(16)
        }
    }
}

#Preview {
    SettingsView()
}
