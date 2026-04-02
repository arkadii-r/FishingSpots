//
//  SpotListViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import Foundation
import Observation
import Combine

@Observable
final class SpotListViewModel {
    enum ScreenState {
        case loading
        case content
        case error(Error)
    }
    
    @ObservationIgnored
    @Injected(\.spotsRepository) var spotsRepository

    var screenState: ScreenState = .loading
    private var spots: [FishingSpot] = []
    var searchText: String = ""
    var spotDetail: FishingSpot?
    
    private var cancellables = Set<AnyCancellable>()
    
    var filteredSpots: [FishingSpot] {
        searchText.isEmpty ? spots : spots.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    private func bindSpots() {
        self.spotsRepository.spots
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { spots in
                self.spots = spots
                self.screenState = .content
            })
            .store(in: &cancellables)
    }
    
    func onAppear() {
        bindSpots()
    }
    
    func retryTapped() {
        self.screenState = .loading
        Task {
            let result = await spotsRepository.loadSpots()
            switch result {
            case let .success(spots):
                self.spots = spots
                self.screenState = .content
                
            case let .failure(error):
                self.screenState = .error(error)
            }
        }
    }
    
    func deleteSpot(_ spot: FishingSpot) {
        Task {
            try? await spotsRepository.deleteSpot(spot)
        }
    }
}
