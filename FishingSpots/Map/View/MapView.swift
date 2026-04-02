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
            markers: $viewModel.markers,
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
        .onAppear {
            viewModel.onAppear()
        }
        .sheet(item: $viewModel.spotDetail) { spot in
            NavigationStack {
                SpotDetailView(viewModel: .init(spot: spot))
            }
        }
        .sheet(item: $viewModel.newSpot) { newSpot in
            AddSpotView(viewModel: .init(newSpot: newSpot))
                .presentationBackground(
                    LinearGradient(
                        colors:[
                            AppTheme.Colors.fsPrimaryGreen,
                            AppTheme.Colors.fsSecondaryGreen
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .presentationDetents([.medium])
        }
    }
}

private extension MapView {
    var selectionCardView: some View {
        VStack(alignment: .leading, spacing: 20) {
            switch viewModel.selectedLocation {
            case let .coordinate(coordinate):
                selectionTitleView(title: coordinate.coordinateString)
                
                Button(Constant.Button.addSpot) {
                    viewModel.addSpot(at: coordinate)
                }
                .buttonStyle(
                    .fsButton(
                        .primary,
                        size: .small,
                        isLoading: viewModel.isLoadingLocationAddress
                    )
                )
                
            case let .marker(marker):
                selectionTitleView(title: marker.title ?? marker.position.coordinateString)
                
                Button(Constant.Button.showSpotDetails) {
                    viewModel.showSpotDetail(marker: marker)
                }
                .buttonStyle(.fsButton(.primary, size: .small))
                
            default:
                EmptyView()
            }
        }
        .padding()
        .background(.clear)
    }
    
    func selectionTitleView(title: String) -> some View {
        HStack(spacing: 10) {
            Text(title)
                .foregroundColor(AppTheme.Colors.black)
                .font(AppTheme.Fonts.header3Bold)
            
            Image(systemName: "plus.magnifyingglass")
                .resizable()
                .frame(width: 24, height: 24)
        }
        .contentShape(.rect)
        .onTapGesture {
            if let cameraPosition = viewModel.getCameraPosition() {
                camera = cameraPosition
            }
        }
    }
}

#Preview {
    MapView(viewModel: .init())
        .ignoresSafeArea()
}
