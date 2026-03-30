//
//  FSTextField.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 22.03.2026.
//

import Foundation
import SwiftUI

struct FSTextField: View {
    let label: String?
    @Binding var text: String
    @FocusState var isFocused: Bool
    let keyboardType: UIKeyboardType
    var validate: Bool
    let maxSymbols: Int?
    
    var validationFailed: Bool {
        !validate && !text.isEmpty
    }
    
    var foregroundColor: Color {
        switch isFocused {
        case true:
            return AppTheme.Colors.fsPrimaryGreen
        case false:
            return AppTheme.Colors.gray
        }
    }
    
    var backgroundColor: Color {
        switch isFocused {
        case true:
            return AppTheme.Colors.white
        case false:
            return validationFailed ? AppTheme.Colors.backgroundRed : AppTheme.Colors.lightGray
        }
    }
    
    init(
        label: String?,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        validate: Bool = true,
        maxSymbols: Int? = nil
    ) {
        self.label = label
        self._text = text
        self.keyboardType = keyboardType
        self.validate = validate
        self.maxSymbols = maxSymbols
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                if let label = label {
                    Text(label)
                        .font(AppTheme.Fonts.caption1)
                        .foregroundColor(foregroundColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isFocused = true
                        }
                }
                
                TextField("", text: $text)
                    .tint(AppTheme.Colors.fsPrimaryGreen)
                    .foregroundColor(AppTheme.Colors.adaptiveBlack)
                    .focused($isFocused)
                    .onChange(of: text) { _, newValue in
                        if let length = maxSymbols,
                           newValue.count > length {
                            text = String(newValue.prefix(length))
                        }
                    }
            }
        }
        .keyboardType(keyboardType)
        .padding()
        .frame(height: 56)
        .background(backgroundColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(foregroundColor,
                        lineWidth: isFocused ? 2 : 0)
        )
    }
}

struct FSTextField_Previews: PreviewProvider {
    static var previews: some View {
        FSTextField(label: "Email", text: .constant("gmail@gmail.com"))
    }
}
