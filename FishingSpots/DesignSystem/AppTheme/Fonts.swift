//
//  Fonts.swift
//  AnlglersSociety
//
//  Created by Ратевосян Аркадий Владимирович on 12.03.2026.
//

import Foundation
import SwiftUI

extension AppTheme {
    public enum Fonts {
        /// Size 12
        public static let caption1 = Font.system(size: 12, weight: .regular)
        public static let caption1Bold = Font.system(size: 12, weight: .semibold)
        
        /// Size 11
        public static let bodyXS = Font.system(size: 11, weight: .regular)
        public static let bodyXSBold = Font.system(size: 11, weight: .semibold)
        
        /// Size 13
        public static let bodyS = Font.system(size: 13, weight: .regular)
        public static let bodySBold = Font.system(size: 13, weight: .semibold)
        
        /// Size 15
        public static let body = Font.system(size: 15, weight: .regular)
        public static let bodyBold = Font.system(size: 15, weight: .semibold)
        
        /// Size 16
        public static let callout = Font.system(size: 16, weight: .regular)
        public static let calloutBold = Font.system(size: 16, weight: .semibold)
        
        /// Size 18
        public static let header3 = Font.system(size: 18, weight: .regular)
        public static let header3Bold = Font.system(size: 18, weight: .semibold)
        
        /// Size 20
        public static let title3 = Font.system(size: 20, weight: .regular)
        public static let title3Bold = Font.system(size: 20, weight: .semibold)
        
        /// Size 22
        public static let header2 = Font.system(size: 22, weight: .regular)
        public static let header2Bold = Font.system(size: 22, weight: .semibold)
        
        /// Size 28
        public static let header1 = Font.system(size: 28, weight: .regular)
        public static let header1Bold = Font.system(size: 28, weight: .semibold)
        
        /// Size 32
        public static let header = Font.system(size: 32, weight: .regular)
        public static let headerBold = Font.system(size: 32, weight: .semibold)
        
        /// Size 38
        public static let display = Font.system(size: 38, weight: .regular)
        public static let displayBold = Font.system(size: 38, weight: .semibold)
    }
}
