//
//  FishingSpotDTO.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 05.04.2026.
//

import Foundation
import FirebaseFirestore

struct FishingSpotDTO: Codable {
    @DocumentID var id: String?
    let name: String
    let location: String
    let latitude: Double
    let longitude: Double
    let catchReports: [CatchReportDTO]
    let createdAt: Date
}
