//
//  URL+extractStoragePhotoFileName.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 04.04.2026.
//

import Foundation

extension URL {
    func extractStoragePhotoFileName() -> String? {
        guard let decodedPath = self.lastPathComponent.removingPercentEncoding else { return nil }
        return decodedPath.components(separatedBy: "/").last
    }
}
