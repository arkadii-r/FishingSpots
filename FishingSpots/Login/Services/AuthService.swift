//
//  AuthService.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 23.03.2026.
//

import Foundation
import FirebaseAuth

final class AuthService {
    func login(email: String, password: String) async -> Result<AuthDataResult, Error> {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    func register(username: String, email: String, password: String) async -> Result<AuthDataResult, Error> {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            try await changeRequest?.commitChanges()
            return .success(result)
            
        } catch {
            return .failure(error)
        }
    }
}
