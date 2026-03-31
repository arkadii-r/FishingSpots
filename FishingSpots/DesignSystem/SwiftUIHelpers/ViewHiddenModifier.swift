//
//  ViewHiddenModifier.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 24.03.2026.
//

import Foundation
import SwiftUI

struct ViewHiddenModifier: ViewModifier {
    let isHidden: Bool

    func body(content: Content) -> some View {
        if isHidden {
            content.hidden()
        } else {
            content
        }
    }
}

extension View {
    public func isHidden(_ isHidden: Bool) -> some View {
        self.modifier(ViewHiddenModifier(isHidden: isHidden))
    }
}
