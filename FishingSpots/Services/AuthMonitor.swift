//
//  AuthMonitor.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 05.04.2026.
//

import Foundation
import FirebaseAuth

final class AuthMonitor {
    private var authStateListener: AuthStateDidChangeListenerHandle?
    var authStateHandler: ((Auth) -> Void)?
    
    
    
    init() {}

    func listenToAuthState() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (auth, _) in
            self?.authStateHandler?(auth)
        }
    }

    func removeListener() {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
}
