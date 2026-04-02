//
//  CatchReport.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation
import FirebaseFirestore

struct CatchReport: Identifiable, Equatable, Codable {
    @DocumentID var id: String?
    let fish: String
    let weight: Double
    let count: Int
    let photoURL: URL?
    let date: String
        
    var weightString: String {
        return "\(String(format: "%.2f", weight)) KG"
    }
}
