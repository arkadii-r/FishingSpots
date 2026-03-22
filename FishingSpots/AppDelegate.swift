//
//  AppDelegate.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 20.03.2026.
//

import Foundation
import UIKit
import FirebaseCore
import GoogleMaps


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyCDRk6dDENnEe3krPg5_GPqZ4Jjzy3KKHw")
        return true
    }
}
