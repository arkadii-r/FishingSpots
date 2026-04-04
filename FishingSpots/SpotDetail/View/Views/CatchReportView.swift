//
//  CatchReportView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 04.04.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let weight = "WEIGHT: "
        static let notes = "notes: "
    }
}

struct CatchReportView: View {
    let report: CatchReport
    let imageTapAction: (Image) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
               switch report.photoURL {
               case let .some(url):
                   AsyncImage(url: url) { image in
                       image
                           .resizable()
                           .overlay(alignment: .bottomTrailing) {
                               Image(systemName: "plus.magnifyingglass")
                                   .padding(1)
                                   .background(AppTheme.Colors.white.opacity(0.4))
                                   .cornerRadius(24)
                           }
                           .onTapGesture {
                               imageTapAction(image)
                           }
                   } placeholder: {
                       ProgressView()
                   }
                   .frame(width: 80, height: 80)
                   .cornerRadius(10)


               case .none:
                   Image(systemName: "camera")
                       .frame(width: 60, height: 60)
                       .background(AppTheme.Colors.white)
                       .cornerRadius(16)
                }
                
                VStack(alignment: .leading, spacing: .zero) {
                    Text("\(report.fish) x\(report.count)")
                        .font(AppTheme.Fonts.calloutBold)
                    
                    Text(Constant.Text.weight + report.weightString)
                        .font(AppTheme.Fonts.bodyS)
                }
                
                Spacer()
                
                Text(report.date, format: .dateTime)
                    .font(AppTheme.Fonts.bodyS)
            }
            
            if !report.note.isEmpty {
                VStack(alignment: .leading, spacing: .zero) {
                    Text(Constant.Text.notes)

                    Text(report.note)
                }
                .font(AppTheme.Fonts.bodyXS)
            }
        }
        .foregroundColor(AppTheme.Colors.black)
    }
}

#Preview {
    CatchReportView(
        report: .init(
            id: UUID().uuidString,
            fish: "Pike",
            weight: 3.143,
            count: 1,
            date: .now,
            note: "catch in the woods"
        ),
        imageTapAction: { _ in
        }
    )
}
