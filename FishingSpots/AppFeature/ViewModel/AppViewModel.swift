//
//  AppViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 24.03.2026.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
class AppViewModel {
    @ObservationIgnored
    @Injected(\.spotsRepository) var spotsRepository
    
    enum AppState: Equatable {
        case loading
        case greeting(username: String)
        case login
        case main
    }
    
    var appState: AppState = .loading
    var authHandle: AuthStateDidChangeListenerHandle?
    
    func onAppear() {
        listenToAuthChanges()
    }
    
    func listenToAuthChanges() {
        authHandle = Auth.auth().addStateDidChangeListener { auth, user in
            switch auth.currentUser {
            case let .some(user):
                self.spotsRepository.bindSpotsListener()
                
                guard let username = user.displayName ?? user.email else {
                    self.appState = .main
                    return
                }
                
                self.appState = .greeting(username: username)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.appState = .main
                }
                
            case .none:
                self.spotsRepository.removeSpotsListener()
                self.appState = .login
            }
        }
    }
}
