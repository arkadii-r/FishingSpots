//
//  LoginView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 22.03.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let title: String = "Fishing Spots"
        static let email: String = "Email"
        static let password: String = "Password"
    }
    
    struct Button {
        static let login: String = "Login"
        static let signUp: String = "Don't have an account? Sign up."
    }
}

struct LoginView: View {
    enum FocusedField {
        case email
        case password
    }
    
    @State private var viewModel: LoginViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .padding()
            .onTapGesture {
                focusedField = nil
            }
            .disabled(viewModel.isLoadingAuth)
            .sheet(isPresented: $viewModel.registerSheetShown) {
                NavigationStack {
                    RegisterView(viewModel: .init(authService: AuthService()))
                        .navigationTitle(Constant.Button.signUp)
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
    }
}

private extension LoginView {
    var contentView: some View {
        VStack(spacing: 60) {
            Image(.fishingSpotsLogo)
            
            VStack(spacing: 16) {
                FSTextField(
                    label: Constant.Text.email,
                    text: $viewModel.emailText,
                    keyboardType: .emailAddress,
                    validate: viewModel.emailText.isValidEmail
                )
                .textContentType(.emailAddress)
                .focused($focusedField, equals: .email)
                
                FSTextField(
                    label: Constant.Text.password,
                    text: $viewModel.passwordText
                )
                .textContentType(.password)
                .focused($focusedField, equals: .password)
            }
            
            VStack(spacing: 16) {
                Button(Constant.Button.login) {
                    focusedField = nil
                    viewModel.login()
                }
                .buttonStyle(.fsButton(.primary, isLoading: viewModel.isLoadingAuth))
                .disabled(!viewModel.loginButtonEnabled)
                
                Button(Constant.Button.signUp) {
                    focusedField = nil
                    viewModel.registerSheetShown = true
                }
                .buttonStyle(.fsButton(.secondary))
                
                if let errorText = viewModel.errorText {
                    Text(errorText)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

#Preview {
    LoginView(viewModel: .init(authService: AuthService()))
}
