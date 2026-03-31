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

@Observable
final class MapViewModel {
    enum LocationType {
        case coordinate(CLLocationCoordinate2D)
        case marker(GMSMarker)
    }
    
    var spots: [FishingSpot] = [.init(name: "Lake", location: "Lake", latitude: 60.388581, longitude: 28.915037, catchReports: [])]
    var selectedLocation: LocationType?
    var spotDetail: FishingSpot?
    var isLoadingAdding: Bool = false
    
    var markers: [GMSMarker] {
        spots.map {
            let marker = GMSMarker(position: .init(latitude: $0.latitude, longitude: $0.longitude))
            marker.title = $0.name
            return marker
        }
    }
    
    func addSpot(at coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        if let request = MKReverseGeocodingRequest(location: location) {
            isLoadingAdding = true
            Task {
                let mapitems = try? await request.mapItems
                isLoadingAdding = false
                if let mapitem = mapitems?.first {
//                    let sda = mapitem.addressRepresentations?.cityWithContext(.full)
                }
            }
        }
    }
    
    func showSpotDetail(marker: GMSMarker) {
        guard let spot = spots.first(where: { $0.latitude == marker.position.latitude && $0.longitude == marker.position.longitude }) else { return }
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
