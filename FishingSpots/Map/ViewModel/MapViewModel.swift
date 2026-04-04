//
//  MapViewModel.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import Foundation
import Observation
import GoogleMaps
import MapKit
import Combine

@Observable
final class MapViewModel {
    enum LocationType {
        case coordinate(CLLocationCoordinate2D)
        case marker(GMSMarker)
    }
    
    @ObservationIgnored
    @Injected(\.spotsRepository) var spotsRepository
    
    var markers: [GMSMarker] = []
    var selectedLocation: LocationType?
    var spotDetail: FishingSpot?
    var isLoadingLocationAddress: Bool = false
    var newSpot: FishingSpot?
    
    
    private var cancellables = Set<AnyCancellable>()
    
    private func bindSpots() {
        self.spotsRepository.spots
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { spots in
                self.markers = spots.map {
                    let marker = GMSMarker(position: $0.coordinate)
                    marker.title = $0.name
                    return marker
                }
            })
            .store(in: &cancellables)
        
        self.spotsRepository.newSpot
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { spot in
                self.newSpot = nil
                self.selectedLocation = nil
                self.spotDetail = spot
            })
            .store(in: &cancellables)
    }
    
    func onAppear() {
        bindSpots()
    }
        
    func addSpot(at coordinate: CLLocationCoordinate2D) {
        var spot: FishingSpot = .init(
            location: "",
            coordinate: coordinate
        )
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard let request = MKReverseGeocodingRequest(location: location) else {
            self.newSpot = spot
            return
        }
        
        isLoadingLocationAddress = true

        Task {
            let mapItems = try? await request.mapItems
            isLoadingLocationAddress = false
            if let address = mapItems?.first?.addressRepresentations?.cityWithContext(.full) {
                spot.location = address
            }
            self.newSpot = spot
        }
    }
    
    func showSpotDetail(marker: GMSMarker) {
        guard let spot = spotsRepository.spots.value.first(where: { $0.coordinate == marker.position }) else { return }
        spotDetail = spot
    }
    
    func getCameraPosition() -> GMSCameraPosition? {
        switch selectedLocation {
        case let .coordinate(coordinate):
            return GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)

        case let .marker(marker):
            return GMSCameraPosition(latitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 15)

        case .none:
            return nil
        }
    }
}
