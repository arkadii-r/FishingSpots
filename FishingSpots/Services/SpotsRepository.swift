//
//  SpotsRepository.swift
//  FishingSpots
//
//  Created by Ратевосян Аркадий Владимирович on 02.04.2026.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseStorage
import FirebaseAuth

final class SpotsRepository {
    private let store = Firestore.firestore().collection("users")
    private let cloudStorage = Storage.storage().reference()
    private let path = "spots"
    private var spotsListener: ListenerRegistration?
    
    var userId: String {
        Auth.auth().currentUser?.uid ?? ""
    }
    
    var spots = CurrentValueSubject<[FishingSpot], Never>([])
    var newSpot: PassthroughSubject<FishingSpot, Never> = .init()
    
    init() {}
    
    // MARK: - Listeners handling
    
    func bindSpotsListener() {
        spotsListener = store
            .document(userId)
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
    
    func removeSpotsListener() {
        spotsListener?.remove()
    }
    
    // MARK: - Spots handling

    
    func loadSpots() async -> Result<[FishingSpot], Error> {
        do {
            let querySnapshot = try await store.document(userId).collection(path).getDocuments()
            let spots = querySnapshot.documents.compactMap { try? $0.data(as: FishingSpot.self) }
            return .success(spots)
        } catch {
            return .failure(error)
        }
    }
    
    func addSpot(_ spot: FishingSpot) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try store.document(userId).collection(path).addDocument(from: spot)
                continuation.resume()
            }
            catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func addCatchReport(for spotId: String, report: CatchReport) async throws {
        let data = try Firestore.Encoder().encode(report)

        try await store.document(userId).collection(path).document(spotId).updateData([
            "catchReports": FieldValue.arrayUnion([data])
        ])
    }
    
    func deleteSpot(_ spot: FishingSpot) async throws {
        try await store.document(userId).collection(path).document(spot.id ?? "").delete()
    }
}

// MARK: - Storage

extension SpotsRepository {
    func uploadImage(image: UIImage) async throws -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else { return nil }
        let imageRef = cloudStorage.child("images/\(UUID().uuidString).jpg")
        
        let _ = try await imageRef.putDataAsync(imageData)
        let imageUrl = try await imageRef.downloadURL()
        
        return imageUrl
    }
}
