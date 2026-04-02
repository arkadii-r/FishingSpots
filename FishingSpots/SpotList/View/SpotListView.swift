//
//  SpotListView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 25.03.2026.
//

import SwiftUI

private struct Constant {    
    static let navigationTitle = "Spot List"
}

struct SpotListView: View {
    @State private var viewModel: SpotListViewModel
    @Environment(TabCoordinator.self) private var tabCoordinator

    
    init(viewModel: SpotListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .navigationTitle(Constant.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        tabCoordinator.selection = .map
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(AppTheme.Fonts.header1)
                    }
                    .buttonStyle(.tapStyle)
                }
            }
    }
}

private extension SpotListView {
    var contentView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredSpots) { spot in
                    NavigationLink {
                        SpotDetailView(viewModel: .init(spot: spot))
                    } label: {
                        SpotCardView(
                            spot: spot,
                            deleteAction: {
                                viewModel.deleteSpot(spot)
                            }
                        )
                    }
                    .buttonStyle(.tapStyle)
                }
            }
            .padding()
            .animation(.default.speed(2), value: viewModel.filteredSpots)
        }
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    NavigationStack {
        SpotListView(viewModel: .init())
    }
}
