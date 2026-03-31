//
//  AppDelegate.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 20.03.2026.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AppServices.run()
        return true
    }
}
