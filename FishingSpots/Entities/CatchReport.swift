//
//  CatchReport.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation
import FirebaseFirestore

struct CatchReport: Identifiable, Equatable {
    let id: String
    var fish: String
    var weight: Double
    var count: Int
    var photoURL: URL?
    var date: Date
    var note: String
        
    var weightString: String {
        return "\(String(format: "%.2f", weight)) KG"
    }
}
