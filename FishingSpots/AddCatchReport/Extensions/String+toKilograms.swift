//
//  String+toKilograms.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 03.04.2026.
//

import Foundation

extension String {
    var toKilograms: Double {
        guard let value = Double(self) else { return 0.0 }
        let grams = Measurement(value: value, unit: UnitMass.grams)
        return grams.converted(to: .kilograms).value
    }
}
