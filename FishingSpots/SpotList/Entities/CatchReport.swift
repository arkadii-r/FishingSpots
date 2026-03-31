//
//  CatchReport.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation

struct CatchReport: Identifiable, Equatable {
    let fish: String
    let weight: Double
    let count: Int
    let photoURL: URL?
    let date: String
    
    let id: UUID = UUID()
    
    var weightString: String {
        return "\(String(format: "%.2f", weight)) KG"
    }
}
