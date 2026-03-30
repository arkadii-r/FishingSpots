//
//  Colors.swift
//  AnlglersSociety
//
//  Created by Ратевосян Аркадий Владимирович on 12.03.2026.
//

import Foundation
import SwiftUI

extension AppTheme {
    public enum Colors {
        public static let adaptiveBlack = Color(light: .black, dark: .white)
        public static let adaptiveWhite = Color(light: .white, dark: .black)
        
        public static let black = Color.black
        public static let white = Color.white
        
        /// hex: #666E3B
        public static let fsPrimaryGreen = Color(hex: "#666E3B")
        
        public static let gray = Color.gray
        /// hex: #E5E7EB
        public static let disabledGray = Color(hex: "#E5E7EB")
        /// hex: #F3F4F6
        public static let lightGray = Color(hex: "#F3F4F6")
        /// hex: #605D66
        public static let darkGray = Color(hex: "#605D66")
        
        /// hex: #51B272
        public static let green = Color(hex: "#51B272")
        /// hex: #C31E1E
        public static let red = Color(hex: "#C31E1E")
        
        /// hex: #6B7280
        public static let contentSecondary = Color(hex: "#6B7280")

        /// hex: #F2F3F5
        public static let backgroundGray = Color(uiColor: .secondarySystemBackground)
        /// hex: #F6F7F8
        public static let backgroundTertiary = Color(hex: "#F6F7F8")
        /// hex: #E02A2A1A
        public static let backgroundRed = Color(hex: "#E02A2A1A")
    }
}
