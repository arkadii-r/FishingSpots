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
import CoreLocation

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
                        if let newSpot = try? change.document.data(as: FishingSpotDTO.self),
                           let domain = newSpot.domainModel {
                            self.newSpot.send(domain)
                        }
                    }
                }
                
                let spotsDTO = snapshot.documents.compactMap { try? $0.data(as: FishingSpotDTO.self) }
                let spots = spotsDTO.compactMap(\.domainModel)
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
            let spotsDTO = querySnapshot.documents.compactMap { try? $0.data(as: FishingSpotDTO.self) }
            let spots = spotsDTO.compactMap(\.domainModel)
            return .success(spots)
        } catch {
            return .failure(error)
        }
    }
    
    func addSpot(_ spot: FishingSpot) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let spotDTO: FishingSpotDTO = .init(name: spot.name, location: spot.location, latitude: spot.coordinate.latitude, longitude: spot.coordinate.longitude, catchReports: [], createdAt: spot.createdAt)
                try store.document(userId).collection(path).addDocument(from: spotDTO)
                continuation.resume()
            }
            catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func addCatchReport(for spotId: String, report: CatchReport) async throws {
        let reportDTO: CatchReportDTO = .init(
            id: report.id,
            fish: report.fish,
            weight: report.weight,
            count: report.count,
            photoURL: report.photoURL,
            date: report.date,
            note: report.note
        )
        
        let data = try Firestore.Encoder().encode(reportDTO)

        try await store.document(userId).collection(path).document(spotId).updateData([
            "catchReports": FieldValue.arrayUnion([data])
        ])
    }
    
    func deleteSpot(_ spot: FishingSpot) async throws {
        try await store.document(userId).collection(path).document(spot.id).delete()
        let imageUrls = spot.catchReports.compactMap { $0.photoURL }
        for imageUrl in imageUrls {
            await deleteImage(url: imageUrl)
        }
    }
}

// MARK: - Storage

extension SpotsRepository {
    func uploadImage(image: UIImage) async throws -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let imageRef = cloudStorage.child("images/\(UUID().uuidString).jpg")
        
        let _ = try await imageRef.putDataAsync(imageData)
        let imageUrl = try await imageRef.downloadURL()
        
        return imageUrl
    }
    
    private func deleteImage(url: URL) async {
        guard let imageFileName = url.extractStoragePhotoFileName() else { return }
        let imageRef = cloudStorage.child("images/\(imageFileName)")
        
        try? await imageRef.delete()
    }
}
