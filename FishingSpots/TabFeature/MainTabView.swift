//
//  MainTabView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 24.03.2026.
//

import SwiftUI

private struct Constant {
    struct Tab {
        static let spotList = "Spot List"
        static let map = "Map"
        static let settings = "Settings"
    }
}

struct MainTabView: View {
    enum Tabs {
        case list
        case map
        case weather
        case settings
    }
    
    @State var coordinator: TabCoordinator = .init()
    
    var body: some View {
        TabView(selection: $coordinator.selection) {
            Tab(
                value: TabCoordinator.Tabs.list,
                content: {
                    NavigationStack {
                        SpotListView(viewModel: .init())
                            .environment(coordinator)
                    }
                },
                label: {
                    Text(Constant.Tab.spotList)
                    Image(.fishingSpotsTab)
                }
            )
            
            Tab(
                value: TabCoordinator.Tabs.map,
                content: {
                    MapView(viewModel: .init())
                        .ignoresSafeArea()
                },
                label: {
                    Text(Constant.Tab.map)
                    Image(.mapTab)
                }
            )
            
            Tab(
                Constant.Tab.settings,
                systemImage: "gearshape.2",
                value: TabCoordinator.Tabs.settings,
            ) {
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .tint(AppTheme.Colors.adaptiveBlack)
    }
}

#Preview {
    MainTabView()
}
