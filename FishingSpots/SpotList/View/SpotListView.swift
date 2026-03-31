//
//  SpotListView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let coordinates = "coordinates:"
    }
    
    struct Button {
    }
    
    static let navigationTitle = "Spot List"
}

struct SpotListView: View {
    @State private var viewModel: SpotListViewModel
    
    init(viewModel: SpotListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .navigationTitle(Constant.navigationTitle)
            .sheet(item: $viewModel.spotDetail) { spot in
                Text(spot.name)
            }
    }
}

private extension SpotListView {
    var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.spots) { spot in
                    spotCardView(for: spot)
                        .contentShape(.rect)
                        .onTapGesture {
                            viewModel.spotDetail = spot
                        }
                }
            }
            .padding()
        }
    }
    
    func spotCardView(for spot: FishingSpot) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(spot.name)
                        .font(AppTheme.Fonts.header2Bold)
                        .foregroundColor(AppTheme.Colors.black)
                    
                    HStack(spacing: 3) {
                        Image(.hookedFish)
                            .resizable()
                            .frame(width: 25, height: 25)
                        
                        Text(spot.catchCount)
                            .foregroundColor(AppTheme.Colors.black)
                            .font(AppTheme.Fonts.bodyS.monospaced())
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 16) {
                    Text(spot.location)
                        .foregroundColor(AppTheme.Colors.black)
                        .font(AppTheme.Fonts.calloutBold)
                    
                    VStack(alignment: .trailing, spacing: .zero) {
                        Text(Constant.Text.coordinates)
                        Text("\(spot.latitude), \(spot.longitude)")
                    }
                    .foregroundColor(AppTheme.Colors.black)
                    .font(AppTheme.Fonts.bodyS.monospaced())
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                stops: [
                    .init(color: AppTheme.Colors.fsPrimaryGreen, location: 0.45),
                    .init(color: AppTheme.Colors.fsSecondaryGreen, location: 0.95)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .shadow(
                    color: AppTheme.Colors.fsPrimaryGreen.opacity(0.5),
                    radius: 5,
                    x: 5,
                    y: 5
                )
        )
    }
}

#Preview {
    NavigationStack {
        SpotListView(viewModel: .init())
    }
}
