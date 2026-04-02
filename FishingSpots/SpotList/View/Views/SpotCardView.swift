//
//  SpotCardView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let coordinates = "coordinates:"
    }
    
    struct Alert {
        static let title = "Are you sure? Spot and all its catches reports will be deleted"
    }
    
    static let thresholdValue: CGFloat = 75
}


struct SpotCardView: View {
    @State private var offset = CGSize.zero
    @State private var deleteConfirmationAlertPresented: Bool = false

    let spot: FishingSpot
    let deleteAction: () -> Void
    
    
    var offsetValue: CGFloat {
        guard offset.width <= -Constant.thresholdValue else { return min(0, offset.width) }
        return -Constant.thresholdValue
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Button {
                offset = .zero
                deleteConfirmationAlertPresented = true
            } label: {
                Image(systemName: "trash")
                    .font(AppTheme.Fonts.header2)
                    .foregroundColor(AppTheme.Colors.red)

            }
            .offset(x: 55)
            
            contentView
                .gesture(
                    DragGesture(minimumDistance: 30)
                        .onChanged { gesture in
                            offset = gesture.translation
                        }
                        .onEnded { _ in
                            guard abs(offset.width) < Constant.thresholdValue else { return }
                            offset = .zero
                        }
                )
        }
        .offset(x: offsetValue)
        .onDisappear {
            offset = .zero
        }
        .animation(.spring, value: offset)
        .alert(
            Constant.Alert.title,
            isPresented: $deleteConfirmationAlertPresented,
            actions: {
                Button(role: .cancel) {
                    deleteConfirmationAlertPresented = false
                }
                
                Button(role: .destructive) {
                    deleteConfirmationAlertPresented = false
                    deleteAction()
                }
            }
        )
    }
}

private extension SpotCardView {
    var contentView: some View {
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
                        Text(spot.coordinatesString)
                    }
                    .foregroundColor(AppTheme.Colors.black)
                    .font(AppTheme.Fonts.bodyS.monospaced())
                }
            }
        }
        .padding()
        .background(FSBackgroundGradientView())
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
    SpotCardView(
        spot: .init(
            name: "Salt Lake",
            location: "Salt Lake City",
            latitude: 30.43134,
            longitude: 40.43134,
            catchReports: [
                .init(
                    fish: "Trout",
                    weight: 3.14,
                    count: 1,
                    photoURL: nil,
                    date: "18:00, 23 April 2024"
                ),
                .init(
                    fish: "Bass",
                    weight: 4.71,
                    count: 10,
                    photoURL: nil,
                    date: "18:00, 23 April 2024"
                )
            ]
        ),
        deleteAction: {}
    )
    .padding()
}
