//
//  RegisterView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 29.03.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let enterUsername: String = "Enter username"
        static let enterEmail: String = "Enter email"
        static let enterPassword: String = "Enter password"
    }
    
    struct PasswordValidation {
        static let minLength: String = "Password must be at least 8 characters long"
        static let containsNumber: String = "Password must contain at least one number"
        static let containsUppercase: String = "Password must contain at least one uppercase letter"
        static let containsLowercase: String = "Password must contain at least one lowercase letter"
        static let containsSpecialCharacter: String = "Password must contain at least one special character (!@#$%^&*)"
    }
    
    struct Button {
        static let signUp: String = "Sign Up"
    }
}

struct RegisterView: View {
    enum FocusedField {
        case username
        case email
        case password
    }
    
    @State private var viewModel: RegisterViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            contentView
                .padding()
                .containerRelativeFrame(.vertical, alignment: .top)
                .onTapGesture {
                    focusedField = nil
                }
        }
    }
}

private extension RegisterView {
    var contentView: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                FSTextField(
                    label: Constant.Text.enterUsername,
                    text: $viewModel.usernameText,
                    validate: !viewModel.usernameText.isEmpty
                )
                .focused($focusedField, equals: .username)
                
                FSTextField(
                    label: Constant.Text.enterEmail,
                    text: $viewModel.emailText,
                    keyboardType: .emailAddress,
                    validate: viewModel.emailText.isValidEmail
                )
                .textContentType(.emailAddress)
                .focused($focusedField, equals: .email)
                
                FSTextField(
                    label: Constant.Text.enterPassword,
                    text: $viewModel.passwordText
                )
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                
                passwordValidationPolicyView
                    .padding(.top, 8)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(Constant.Button.signUp) {
                    focusedField = nil
                    viewModel.signup()
                }
                .buttonStyle(.fsButton(.primary, isLoading: viewModel.isLoadingSignUp))
                .disabled(!viewModel.actionButtonEnabled)
                
                if let errorText = viewModel.errorText {
                    Text(errorText)
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    var passwordValidationPolicyView: some View {
        VStack(alignment: .leading, spacing: 7) {
            passwordValidationRow(
                text: Constant.PasswordValidation.minLength,
                validation: viewModel.passwordText.isEightSymbolsOrMore
            )
            
            passwordValidationRow(
                text: Constant.PasswordValidation.containsLowercase,
                validation: viewModel.passwordText.isContainsLowercaseLetter
            )
            
            passwordValidationRow(
                text: Constant.PasswordValidation.containsUppercase,
                validation: viewModel.passwordText.isContainsUppercaseLetter
            )
            
            passwordValidationRow(
                text: Constant.PasswordValidation.containsNumber,
                validation: viewModel.passwordText.isContainsNumber
            )
            
            passwordValidationRow(
                text: Constant.PasswordValidation.containsSpecialCharacter,
                validation: viewModel.passwordText.isContainsSpecialCharacters
            )
        }
    }
    
    private func passwordValidationRow(text: String, validation: Bool) -> some View {
        Label {
            Text(text)
        } icon: {
            Image(systemName: validation ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(validation ? AppTheme.Colors.green : AppTheme.Colors.red)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    RegisterView(viewModel: .init())
}
