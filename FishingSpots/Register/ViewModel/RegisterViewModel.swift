//
//  RegisterViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 29.03.2026.
//

import Foundation
import Observation
import FirebaseAuth

private struct Constant {
    static let defaultErrorMessage: String = "Something went wrong. Please try again later."
    static let invalidCredentialErrorMessage: String = "Invalid email or password."
}

@Observable
class RegisterViewModel {
    @ObservationIgnored
    @Injected(\.authService) private var authService
    
    var usernameText: String = ""
    var emailText: String = ""
    var passwordText: String = ""
    var isLoadingSignUp: Bool = false
    var errorText: String? = nil
    
    var actionButtonEnabled: Bool {
        !usernameText.isEmpty && emailText.isValidEmail && !passwordText.isEmpty
    }
    
    init() {}
        
    func signup() {
        errorText = nil
        isLoadingSignUp = true
        
        Task {
            let result = await authService.register(username: usernameText, email: emailText, password: passwordText)
            isLoadingSignUp = false
            switch result {
            case .success:
                break
                
            case let .failure(error):
                self.errorText = error.localizedDescription
            }
        }
    }
}
