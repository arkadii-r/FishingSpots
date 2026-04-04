//
//  CatchReportDTO.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 05.04.2026.
//

import Foundation

struct CatchReportDTO: Codable {
    let id: String
    let fish: String
    let weight: Double
    let count: Int
    let photoURL: URL?
    let date: Date
    let note: String
}
