//
//  SpotsRepository.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 02.04.2026.
//

import Foundation
import FirebaseFirestore
import Combine

final class SpotsRepository {
    private let store = Firestore.firestore()
    private let path = "spots"
    
    var spots = CurrentValueSubject<[FishingSpot], Never>([])
    var newSpot: PassthroughSubject<FishingSpot, Never> = .init()
    
    init() {
        bindSpotsListener()
    }
    
    func bindSpotsListener() {
        store
            .collection(path)
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    return
                }
                
                snapshot.documentChanges.forEach { change in
                    if change.type == .added {
                        if let newSpot = try? change.document.data(as: FishingSpot.self) {
                            self.newSpot.send(newSpot)
                        }
                    }
                }
                
                let spots = snapshot.documents.compactMap { try? $0.data(as: FishingSpot.self) }
                self.spots.send(spots)
            }
    }
    
    func loadSpots() async -> Result<[FishingSpot], Error> {
        do {
            let querySnapshot = try await store.collection(path).getDocuments()
            let spots = querySnapshot.documents.compactMap { try? $0.data(as: FishingSpot.self) }
            return .success(spots)
        } catch {
            return .failure(error)
        }
    }
    
    func addSpot(_ spot: FishingSpot) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try store.collection(path).addDocument(from: spot)
                continuation.resume()
            }
            catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func addCatchReport(for spotId: String, report: CatchReport) async throws {
        let data = try Firestore.Encoder().encode(report)

        try await store.collection(path).document(spotId).updateData([
            "catchReports": FieldValue.arrayUnion([data])
        ])
    }
    
    func deleteSpot(_ spot: FishingSpot) async throws {
        try await store.collection(path).document(spot.id ?? "").delete()
    }
}
