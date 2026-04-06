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
import CoreLocation

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
    
    var camera: GMSCameraPosition?
    var locationSettingsAlertPresented: Bool = false
    
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
                let marker = GMSMarker(position: spot.coordinate)
                marker.title = spot.name
                self.selectedLocation = .marker(marker)
                self.spotDetail = spot
            })
            .store(in: &cancellables)
    }
    
    func onAppear() {
        bindSpots()
        centerUserLocation(onAppear: true)
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
    
    func centerUserLocation(onAppear: Bool = false) {
        Task {
            let updates = CLLocationUpdate.liveUpdates()
            do {
                for try await update in updates {
                    guard !update.authorizationDenied else {
                        if !onAppear {
                            self.locationSettingsAlertPresented = true
                        }
                        break
                    }
                    
                    if let location = update.location {
                        self.camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10)
                        break
                    }
                }
            }
            catch {
                
            }
        }
    }
    
    func centerSelectedLocation() {
        switch selectedLocation {
        case let .coordinate(coordinate):
            self.camera = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 15)
            
        case let .marker(marker):
            self.camera = GMSCameraPosition(latitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 15)
            
        case .none:
            self.camera = nil
        }
    }
    
    func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
