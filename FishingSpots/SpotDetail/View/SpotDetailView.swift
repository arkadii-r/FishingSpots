//
//  SpotDetailView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import SwiftUI

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
    }
}

struct SpotDetailView: View {
    @State private var viewModel: SpotDetailViewModel
    
    init(viewModel: SpotDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .padding()
            .background(FSBackgroundGradientView().ignoresSafeArea())
            .navigationTitle(viewModel.spot.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(.hidden, for: .tabBar)
    }
}

private extension SpotDetailView {
    var contentView: some View {
        VStack(alignment: .leading, spacing: 32) {
            infoWidgetView
            
            catchReportsListView
        }
    }
    
    var infoWidgetView: some View {
        VStack(alignment: .leading, spacing: 16) {
            infoView(
                title: Constant.Text.name,
                value: viewModel.spot.name
            )
            
            infoView(
                title: Constant.Text.location,
                value: viewModel.spot.location
            )
            
            HStack(alignment: .bottom) {
                infoView(
                    title: Constant.Text.coordinates,
                    value: viewModel.spot.coordinatesString
                )
                
                Button {
                    viewModel.copyCoordinates()
                } label: {
                    Image(.copy)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .contentShape(.rect)
                }
                .buttonStyle(.tapStyle)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppTheme.Colors.backgroundGray)
        .cornerRadius(16)
    }
    
    func infoView(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.Fonts.callout)
            
            Text(value)
                .font(AppTheme.Fonts.header3Bold)
        }
        .foregroundColor(AppTheme.Colors.black)
    }
    
    var catchReportsListView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(Constant.Text.catchReports)
                    .foregroundColor(AppTheme.Colors.adaptiveBlack)
                    .font(AppTheme.Fonts.header2Bold)
                
                Spacer()
                
                Button {
                    // TODO: ADD CATCH REPORT
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(AppTheme.Fonts.header1Bold)
                }
                .buttonStyle(.tapStyle)
            }
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    if !viewModel.spot.catchReports.isEmpty {
                        ForEach(viewModel.spot.catchReports) { report in
                            reportCardView(for: report)
                            
                            if viewModel.spot.catchReports.last != report {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    } else {
                        Text(Constant.Text.emptyReports)
                            .font(AppTheme.Fonts.header3.monospaced())
                            .foregroundColor(AppTheme.Colors.black)
                            .padding(.vertical)
                    }
                }
                .padding()
                .background(AppTheme.Colors.backgroundGray)
                .cornerRadius(16)
            }
            .cornerRadius(16)
        }
    }
    
    func reportCardView(for report: CatchReport) -> some View {
        HStack {
            AsyncImage(url: report.photoURL) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
            } placeholder: {
                Image(systemName: "camera")
                    .frame(width: 50, height: 50)
                    .background(AppTheme.Colors.white)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: .zero) {
                Text("\(report.fish) x\(report.count)")
                    .font(AppTheme.Fonts.calloutBold)
                
                Text(Constant.Text.weight + report.weightString)
                    .font(AppTheme.Fonts.bodyS)
            }
            .foregroundColor(AppTheme.Colors.black)
            
            Spacer()
            
            Text(report.date)
                .foregroundColor(AppTheme.Colors.black)
                .font(AppTheme.Fonts.bodyS)
        }
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(
            viewModel:
                    .init(
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
                            ],
                            createdAt: .now
                    )
                )
        )
    }
}
