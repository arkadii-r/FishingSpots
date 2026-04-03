//
//  AddCatchReportView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 03.04.2026.
//

import SwiftUI

private struct Constant {
    struct Text {
        static let fishName = "Enter fish name"
        static let weight = "Enter weight (g)"
        static let count = "Count"
        static let date = "Date"
        static let time = "Time"
        static let notes = "Notes"
    }
    
    struct Button {
        static let add = "Add Report"
    }
    
    static let navigationTitle: String = "New Catch Report"
    static let fishCountStepperRange = 1...100
}

struct AddCatchReportView: View {
    enum FocusedField {
        case fishName
        case weight
        case note
    }
    
    @State private var viewModel: AddCatchReportViewModel
    @FocusState var focusedField: FocusedField?
    
    init(viewModel: AddCatchReportViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            contentView
                .padding()
                .onTapGesture {
                    focusedField = nil
                }
        }
        .navigationTitle(Constant.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension AddCatchReportView {
    var contentView: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                FSTextField(
                    label: Constant.Text.fishName,
                    text: $viewModel.newCatchReport.fish,
                    validate: !viewModel.newCatchReport.fish.isEmpty,
                    maxSymbols: 30
                )
                .focused($focusedField, equals: .fishName)
                
                FSTextField(
                    label: Constant.Text.weight,
                    text: $viewModel.weightText,
                    keyboardType: .numberPad,
                    maxSymbols: 5
                )
                .focused($focusedField, equals: .weight)
                
                Stepper(
                    value: $viewModel.newCatchReport.count,
                    in: Constant.fishCountStepperRange,
                    label: {
                        HStack {
                            Text(Constant.Text.count)
                            Spacer()
                            Text("\(viewModel.newCatchReport.count)")
                                .padding(.trailing, 7)
                        }
                    }
                )
                
                DatePicker(
                    Constant.Text.date,
                    selection: $viewModel.newCatchReport.date,
                    in: Date()...,
                    displayedComponents: .date
                )
                .colorScheme(.dark)
                
                DatePicker(
                    Constant.Text.time,
                    selection: $viewModel.newCatchReport.date,
                    in: Date()...,
                    displayedComponents: .hourAndMinute
                )
                .colorScheme(.dark)
            }
            .foregroundColor(AppTheme.Colors.white)
            .fontDesign(.monospaced)
            
            FSTextField(
                label: Constant.Text.notes,
                text: $viewModel.newCatchReport.note,
                maxSymbols: 100,
                lineLimit: 4
            )
            .focused($focusedField, equals: .note)
            .fontDesign(.monospaced)
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(Constant.Button.add) {
                    focusedField = nil
                    viewModel.addSpot()
                }
                .buttonStyle(.fsButton(.secondary, isLoading: viewModel.isLoadingAddButton))
                .disabled(!viewModel.addButtonEnabled)
                
                if let errorText = viewModel.addingErrorText {
                    Text(errorText)
                        .foregroundColor(.red)
                }
            }
        }
        
    }
}

#Preview {
    AddCatchReportView(viewModel: .init(spotId: "", completion: { _ in }))
}
