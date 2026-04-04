//
//  CatchReportDTO+domain.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 05.04.2026.
//

import Foundation

extension CatchReportDTO {
    var domainModel: CatchReport {
        .init(
            id: id,
            fish: fish,
            weight: weight,
            count: count,
            photoURL: photoURL,
            date: date,
            note: note
        )
    }
}
