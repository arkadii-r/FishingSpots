//
//  SpotDetailViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import Foundation
import Observation
import UIKit

@Observable
final class SpotDetailViewModel {
    var spot: FishingSpot
    var addNewReportSheetPresented: Bool = false
    var imageItem: SheetImageItem?
    
    init(spot: FishingSpot) {
        self.spot = spot
    }
    
    
    func addNewReport() {
        addNewReportSheetPresented = true
    }
    
    func handleNewReport(report: CatchReport) {
        spot.catchReports.append(report)
        addNewReportSheetPresented = false
    }
    
    func copyCoordinates() {
        UIPasteboard.general.string = spot.coordinatesString
    }
    
}
