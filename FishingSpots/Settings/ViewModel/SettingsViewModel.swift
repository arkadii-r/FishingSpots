//
//  SettingsViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 29.03.2026.
//

import Foundation
import Observation
import FirebaseAuth
import UIKit

@Observable
final class SettingsViewModel {
    let username: String?
    let userEmail: String?
    var logoutErrorAlertText: String?
    var logoutAlertShown: Bool = false
    var appIcon: Icon
    
    init() {
        username = Auth.auth().currentUser?.displayName
        userEmail = Auth.auth().currentUser?.email
        
        let iconName = UIApplication.shared.alternateIconName
        
        if let iconName, let icon = Icon(rawValue: iconName) {
            appIcon = icon
        } else {
            appIcon = .primary
        }
    }
    
    func setAlternateAppIcon(icon: Icon) {
        let iconName: String? = (icon != .primary) ? icon.rawValue : nil
        
        guard UIApplication.shared.alternateIconName != iconName else { return }
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error {
                print("Failed request to update the app’s icon: \(error)")
            }
        }
        
        appIcon = icon
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            logoutErrorAlertText = error.localizedDescription
        }
    }
}
