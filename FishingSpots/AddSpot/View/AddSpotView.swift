//
//  AddSpotView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 01.04.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let name = "Enter name"
        static let location = "Enter location"
        static let coordinates = "coordinates: "
    }
    
    struct Button {
        static let add = "Add Spot"
    }
}

struct AddSpotView: View {
    @State private var viewModel: AddSpotViewModel
    @FocusState var nameFieldFocused: Bool
    
    init(viewModel: AddSpotViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Text(viewModel.newSpot.coordinatesString)
                .font(AppTheme.Fonts.header3Bold.monospaced())
            
            VStack(spacing: 20) {
                FSTextField(
                    label: Constant.Text.name,
                    text: $viewModel.newSpot.name,
                    validate: !viewModel.newSpot.name.isEmpty,
                    maxSymbols: 30
                )
                .focused($nameFieldFocused)
                
                FSTextField(
                    label: Constant.Text.location,
                    text: $viewModel.newSpot.location
                )
            }
            
            VStack(spacing: 16) {
                Button(Constant.Button.add) {
                    viewModel.addSpot()
                }
                .buttonStyle(.fsButton(.primary, isLoading: viewModel.isLoadingAddButton))
                .disabled(!viewModel.addButtonEnabled)
                
                if let errorText = viewModel.addingErrorText {
                    Text(errorText)
                        .foregroundColor(.red)
                }
            }
        }
        .padding([.horizontal, .bottom])
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                nameFieldFocused = true
            }
        }
    }
}

#Preview {
    AddSpotView(
        viewModel: .init(
            newSpot: .init(
                location: "River, London",
                latitude: 30.312312,
                longitude: 34.444113
            )
        )
    )
}
