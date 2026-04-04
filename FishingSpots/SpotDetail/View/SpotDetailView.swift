//
//  SpotDetailView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 31.03.2026.
//

import SwiftUI
import CoreLocation

private struct Constant {
    struct Text {
        static let name = "Name"
        static let location = "Location"
        static let coordinates = "Coordinates"
        static let catchReports = "Catch Reports"
        static let emptyReports = "No catch reports yet"
    }
}

struct SpotDetailView: View {
    @State private var viewModel: SpotDetailViewModel
    @State var image: Image?
    
    init(viewModel: SpotDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        contentView
            .padding([.horizontal, .top])
            .background(FSBackgroundGradientView().ignoresSafeArea())
            .navigationTitle(viewModel.spot.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarVisibility(.hidden, for: .tabBar)
            .sheet(isPresented: $viewModel.addNewReportSheetPresented) {
                NavigationStack {
                    AddCatchReportView(
                        viewModel: .init(
                            spotId: viewModel.spot.id,
                            completion: viewModel.handleNewReport(report:)
                        )
                    )
                    .presentationBackground(BlueGradientBackgroundView())
                }
            }
            .sheet(item: $viewModel.imageItem) { imageItem in
                NavigationStack {
                    ZoomableScrollView(content: {
                        imageItem.image
                            .resizable()
                            .scaledToFit()
                    })
                    .navigationTitle(imageItem.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .presentationBackground(BlueGradientBackgroundView())
                }
            }
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
                    viewModel.addNewReport()
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
                            CatchReportView(
                                report: report,
                                imageTapAction: {
                                    viewModel.imageItem = .init(title: report.fish, image: $0)
                                }
                            )
                            
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
            .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(
            viewModel:
                    .init(
                        spot: .init(
                            id: "1",
                            name: "Salt Lake",
                            location: "Salt Lake City",
                            coordinate: .init(latitude: 30.43134, longitude: 40.43134),
                            catchReports: [
                                .init(
                                    id: UUID().uuidString,
                                    fish: "Trout",
                                    weight: 3.14,
                                    count: 1,
                                    photoURL: URL(string: "https://firebasestorage.googleapis.com:443/v0/b/fishing-spots-59a3d.firebasestorage.app/o/images%2F8E574C5F-D514-470A-884B-03FCB5E7BBCD.jpg?alt=media&token=555a9e4a-7d51-4d5f-9692-2e27b916bd59")!,
                                    date: .now,
                                    note: "Long text why not so long long long long long"
                                ),
                                .init(
                                    id: UUID().uuidString,
                                    fish: "Bassf",
                                    weight: 4.71,
                                    count: 10,
                                    photoURL: nil,
                                    date: .now,
                                    note: ""
                                )
                            ],
                            createdAt: .now
                        )
                    )
        )
    }
}
