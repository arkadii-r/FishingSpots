//
//  SheetImageItem.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 04.04.2026.
//

import Foundation
import SwiftUI

struct SheetImageItem: Identifiable {
    let id: UUID = UUID()
    let title: String
    let image: Image
}
