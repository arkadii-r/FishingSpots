//
//  AddCatchReportView.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 03.04.2026.
//

import SwiftUI
import PhotosUI

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
    @State private var photoItem: PhotosPickerItem?
    
    init(viewModel: AddCatchReportViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            contentView
                .padding([.horizontal, .top])
                .padding(.bottom, 75)
                .onTapGesture {
                    focusedField = nil
                }
        }
        .overlay(
            alignment: .bottom,
            content: {
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
                .padding([.horizontal, .bottom], 16)
            }
        )
        .navigationTitle(Constant.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension AddCatchReportView {
    var contentView: some View {
        VStack(spacing: 40) {
            photoPickerView
            
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
                    in: ...Date(),
                    displayedComponents: .date
                )
                .colorScheme(.dark)
                
                DatePicker(
                    Constant.Text.time,
                    selection: $viewModel.newCatchReport.date,
                    in: ...Date(),
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
        }
        
    }
    
    var photoPickerView: some View {
        PhotosPicker(
            selection: $photoItem,
            matching: .any(of: [.images, .livePhotos]),
            label: {
                VStack {
                    switch viewModel.selectedImage {
                    case let .some(image):
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                        
                    case .none:
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .foregroundColor(AppTheme.Colors.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: viewModel.selectedImage != nil ? 270 : 150)
                .overlay(alignment: .bottomTrailing) {
                    if viewModel.selectedImage != nil {
                        Image(systemName: "trash")
                            .foregroundColor(AppTheme.Colors.red)
                            .padding(5)
                            .background(AppTheme.Colors.white.opacity(0.5))
                            .cornerRadius(24)
                            .onTapGesture {
                                photoItem = nil
                            }
                    }
                }
            }
        )
        .onChange(of: photoItem) { _ ,newValue in
            viewModel.handlePhotoItemChange(newValue)
        }
    }
}

#Preview {
    AddCatchReportView(viewModel: .init(spotId: "", completion: { _ in }))
}
