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
    
   private var markers: [GMSMarker]
   private let mapType: GMSMapViewType
   
   @Binding var camera: GMSCameraPosition?
    
    private let tapHandler: (CLLocationCoordinate2D) -> Void
    private let markerTapHandler: (GMSMarker) -> Bool
   
   init(
    markers: [GMSMarker] = [],
    mapType: GMSMapViewType = .normal,
    camera: Binding<GMSCameraPosition?>,
    tapHandler: @escaping (CLLocationCoordinate2D) -> Void,
    markerTapHandler: @escaping (GMSMarker) -> Bool
    
   ) {
       self.markers = markers
       self.mapType = mapType
       self._camera = camera
       self.tapHandler = tapHandler
       self.markerTapHandler = markerTapHandler
   }
   
   func makeUIView(context: Context) -> GMSMapView {
       let mapView = GMSMapView()
       mapView.mapType = mapType
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
       
       uiView.mapType = mapType
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
            self.mapView.tapHandler(coordinate)
        }
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            return self.mapView.markerTapHandler(marker)
        }
        
    }
}


extension GoogleMapView {

    func mapType(_ type: GMSMapViewType) -> GoogleMapView {
        GoogleMapView(markers: markers, mapType: type, camera: $camera, tapHandler: tapHandler, markerTapHandler: markerTapHandler)
    }
    
    func mapMarkers(_ markers: [GMSMarker]) -> GoogleMapView {
        var view = self
        view.markers = markers
        return view
    }

}
