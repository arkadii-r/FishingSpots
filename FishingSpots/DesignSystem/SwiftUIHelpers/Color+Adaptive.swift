//
//  Color+Adaptive.swift
//  AnlglersSociety
//
//  Created by Ратевосян Аркадий Владимирович on 12.03.2026.
//

import Foundation
import SwiftUI

extension UIColor {
  convenience init(light: UIColor, dark: UIColor) {
    self.init { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .light, .unspecified:
        return light
      case .dark:
        return dark
      @unknown default:
        return light
      }
    }
  }
}

extension Color {
  init(light: Color, dark: Color) {
    self.init(UIColor(light: UIColor(light), dark: UIColor(dark)))
  }
}
