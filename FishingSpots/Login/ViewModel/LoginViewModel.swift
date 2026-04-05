//
//  LoginViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 22.03.2026.
//

import Foundation
import Observation
import FirebaseAuth

private struct Constant {
    static let defaultErrorMessage: String = "Something went wrong. Please try again later."
    static let invalidCredentialErrorMessage: String = "Invalid email or password."
}

@Observable
@MainActor
class LoginViewModel {
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    @ObservationIgnored
    @Injected(\.authMonitor) var authMonitor
    
    var emailText: String = ""
    var passwordText: String = ""
    var registerSheetShown: Bool = false
    var isLoadingAuth: Bool = false
    var errorText: String? = nil
    
    var loginButtonEnabled: Bool {
        emailText.isValidEmail && !passwordText.isEmpty
    }
    
    init() {}
    
    func login() {
        errorText = nil
        isLoadingAuth = true
        
        Task {
            let result = await authService.login(email: emailText, password: passwordText)
            isLoadingAuth = false
            switch result {
            case .success:
                authMonitor.listenToAuthState()
                
            case let .failure(error):
                guard let authError = AuthErrorCode(rawValue: (error as NSError).code) else {
                    self.errorText = Constant.defaultErrorMessage
                    return
                }
                
                switch authError {
                case .invalidCredential:
                    self.errorText = Constant.invalidCredentialErrorMessage
                    
                default:
                    self.errorText = Constant.defaultErrorMessage
                }
            }
        }
    }
}
