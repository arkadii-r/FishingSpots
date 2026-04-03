//
//  AddCatchReportViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 03.04.2026.
//

import Foundation
import Observation

@Observable
final class AddCatchReportViewModel {
    @ObservationIgnored
    @Injected(\.spotsRepository) private var spotsRepository
    
    private let spotId: String
    
    var newCatchReport: CatchReport = .init(id: UUID().uuidString, fish: "", weight: 0, count: 1, photoURL: nil, date: .now, note: "")
    var weightText: String = ""
    var isLoadingAddButton: Bool = false
    var addingErrorText: String?
    
    var addButtonEnabled: Bool {
        !newCatchReport.fish.isEmpty
    }
    
    let completion: (CatchReport) -> Void
    
    init(
        spotId: String,
        completion: @escaping (CatchReport) -> Void
    ) {
        self.spotId = spotId
        self.completion = completion
    }
    
    func addSpot() {
        addingErrorText = nil
        isLoadingAddButton = true
        Task {
            do {
                newCatchReport.weight = weightText.toKilograms
                try await spotsRepository.addCatchReport(for: spotId, report: newCatchReport)
                isLoadingAddButton = false
                completion(newCatchReport)
            } catch {
                isLoadingAddButton = false
                addingErrorText = error.localizedDescription
            }
        }
    }
}
