//
//  MapView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import SwiftUI
import GoogleMaps

private struct Constant {
    struct Text {
        static let name = "Name"
        static let location = "Location"
        static let coordinates = "Coordinates"
        static let catchReports = "Catch Reports"
        static let emptyReports = "No catch reports yet"
        static let weight = "WEIGHT: "
    }
    
    struct Button {
        static let addSpot = "Add Fishing Spot"
        static let showSpotDetails = "Show Spot Details"
    }
}


struct MapView: View {
    @State private var viewModel: MapViewModel
    @State private var camera: GMSCameraPosition?
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        GoogleMapView(
            markers: viewModel.markers,
            camera: $camera,
            tapHandler: { coordinate in
                viewModel.selectedLocation = .coordinate(coordinate)
            },
            markerTapHandler: { marker in
                viewModel.selectedLocation = .marker(marker)
                return true
            }
        )
        .overlay(alignment: .bottom) {
            selectionCardView
                .padding(.horizontal)
                .padding(.bottom, 120)
                .isHidden(viewModel.selectedLocation == nil)
        }
        .sheet(item: $viewModel.spotDetail) { spot in
            NavigationStack {
                SpotDetailView(viewModel: .init(spot: spot))
            }
        }
    }
}

private extension MapView {
    var selectionCardView: some View {
        VStack(alignment: .leading, spacing: 20) {
            switch viewModel.selectedLocation {
            case let .coordinate(coordinate):
                Text("\(coordinate.latitude), \(coordinate.longitude)")
                    .foregroundColor(AppTheme.Colors.black)
                    .font(AppTheme.Fonts.header3Bold)
                
                Button(Constant.Button.addSpot) {
                    viewModel.addSpot(at: coordinate)
                }
                .buttonStyle(
                    .fsButton(
                        .primary,
                        size: .small,
                        isLoading: viewModel.isLoadingAdding
                    )
                )
                
            case let .marker(marker):
                Text(marker.title ?? "\(marker.position.latitude), \(marker.position.longitude)")
                    .foregroundColor(AppTheme.Colors.black)
                    .font(AppTheme.Fonts.header3Bold)

                Button(Constant.Button.showSpotDetails) {
                    viewModel.showSpotDetail(marker: marker)
                }
                .buttonStyle(.fsButton(.primary, size: .small))
                
            default:
                EmptyView()
            }
        }
        .overlay(alignment: .topTrailing) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    if let cameraPosition = viewModel.getCameraPosition() {
                        camera = cameraPosition
                    }
                }
        }
        .padding()
        .background(AppTheme.Colors.fsSecondaryGreen.opacity(0.9))
        .cornerRadius(20)
    }
}

#Preview {
    MapView(viewModel: .init())
        .ignoresSafeArea()
}
