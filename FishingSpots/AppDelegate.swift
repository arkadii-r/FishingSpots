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

private struct Constant {
    static let googleMapsAPIKey: String = "AIzaSyCDRk6dDENnEe3krPg5_GPqZ4Jjzy3KKHw"
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        GMSServices.provideAPIKey(Constant.googleMapsAPIKey)
        return true
    }
}
