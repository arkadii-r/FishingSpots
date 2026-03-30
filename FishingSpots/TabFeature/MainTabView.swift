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
    
    @State var selection: Tabs = .list
    
    var body: some View {
        TabView(selection: $selection) {
            Tab(
                value: Tabs.list,
                content: {
                },
                label: {
                    Text(Constant.Tab.spotList)
                    Image(.fishingSpotsTab)
                }
            )
            
            Tab(
                value: Tabs.map,
                content: {
                },
                label: {
                    Text(Constant.Tab.map)
                    Image(.mapTab)
                }
            )
            
            Tab(
                Constant.Tab.settings,
                systemImage: "gearshape.2",
                value: Tabs.settings
            ) {
            }
        }
        .tint(AppTheme.Colors.adaptiveBlack)
    }
}

#Preview {
    MainTabView()
}
