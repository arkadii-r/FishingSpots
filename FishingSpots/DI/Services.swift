//
//  Services.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import Foundation
import FirebaseCore
import GoogleMaps

private struct Constant {
    static let googleMapsAPIKey: String = "AIzaSyCDRk6dDENnEe3krPg5_GPqZ4Jjzy3KKHw"
}

class Services {
    // All services should be defined as lazy private(set)
    // If you need to explicitly create an entity, for example,
    // to subscribe to application lifecycle events,
    // initialize the service in the AppServices.run() method
    //
    // In general service registration should look like this:
    //
    // private(set) lazy var service: ServiceProtocol = Service()

    private(set) lazy var authService: AuthService = AuthService()
}

class AppServices {
    static let shared = Services()

    private init() {}
    
    static func run() {
        FirebaseApp.configure()
        GMSServices.provideAPIKey(Constant.googleMapsAPIKey)
    }
}
