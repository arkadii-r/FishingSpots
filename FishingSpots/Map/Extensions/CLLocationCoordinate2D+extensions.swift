//
//  CLLocationCoordinate2D+extensions.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 02.04.2026.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension CLLocationCoordinate2D {
    var coordinateString: String {
        "\(String(format: "%.6f", latitude)), \(String(format: "%.6f", longitude))"
    }
}
