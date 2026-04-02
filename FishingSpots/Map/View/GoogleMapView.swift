//
//  GoogleMapView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 22.03.2026.
//

import Foundation
import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
        
    @State private var selectedCoordinateMarker: GMSMarker?
    @Binding var camera: GMSCameraPosition?
    @Binding var markers: [GMSMarker]
    
    private let tapHandler: (CLLocationCoordinate2D) -> Void
    private let markerTapHandler: (GMSMarker) -> Bool
    
    init(
        markers: Binding<[GMSMarker]>,
        mapType: GMSMapViewType = .normal,
        camera: Binding<GMSCameraPosition?>,
        tapHandler: @escaping (CLLocationCoordinate2D) -> Void,
        markerTapHandler: @escaping (GMSMarker) -> Bool
        
    ) {
        self._markers = markers
        self._camera = camera
        self.tapHandler = tapHandler
        self.markerTapHandler = markerTapHandler
    }
    
    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        if let camera = camera {
            uiView.camera = camera
        }
        
        uiView.clear()
        
        markers.forEach { marker in
            marker.icon = UIImage(resource: .hookedFish)
            marker.map = uiView
        }
        
        if !markers.contains(where: { $0.position == selectedCoordinateMarker?.position }) {
            selectedCoordinateMarker?.map = uiView
        }        
    }
    
    func makeCoordinator() -> GoogleMapViewCoordinator {
        return GoogleMapViewCoordinator(self)
    }
    
    
    final class GoogleMapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GoogleMapView
        
        init(_ mapView: GoogleMapView) {
            self.mapView = mapView
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            self.mapView.camera = nil
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            self.mapView.selectedCoordinateMarker = GMSMarker(position: coordinate)
            self.mapView.tapHandler(coordinate)
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            guard self.mapView.markers.contains(where: { $0.position == marker.position }) else { return false }
            self.mapView.selectedCoordinateMarker = nil
            return self.mapView.markerTapHandler(marker)
        }
        
    }
}
