//
//  FirebaseService.swift
//  rently
//
//  Created by Grace Liao on 11/7/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


extension Auth {
    func createUserAsync(withEmail email: String, password: String) async throws -> AuthDataResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let authResult = authResult {
                    continuation.resume(returning: authResult)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error"]))
                }
            }
        }
    }
}

class FirebaseService {
    static let shared = FirebaseService()

    private init() {}

    func registerUser(firstName: String, email: String, password: String) async throws -> User {
    print("Attempting to create user in Firebase Authentication with:")
    print("First Name: \(firstName)")
    print("Email: \(email)")
    print("Password: \(password)")
        let authResult = try await Auth.auth().createUserAsync(withEmail: email, password: password)
        
        let uid = authResult.user.uid
        print("Firebase Authentication succeeded. User UID: \(uid)")

        let user = User(
            id: uid,
            firstName: firstName,
            lastName: "",
            username: "",
            pronouns: "",
            email: email,
            password: "",
            university: "",
            rating: 0,
            listings: [],
            likedItems: [],
            styleChoices: [],
            events: []
        )

        print("Saving user to Firestore with the following data:")
        print("User ID: \(user.id ?? "No ID")")
        print("First Name: \(user.firstName)")
        print("Email: \(user.email)")
        try await saveUserToFirestore(user)
        
        print("User successfully saved to Firestore.")
        return user
    }

    private func saveUserToFirestore(_ user: User) async throws {
        let db = Firestore.firestore()
        try db.collection("Users").document(user.id!).setData(from: user)
    }

  // upload images to Firebase Storage and get URLs
  func uploadImages(_ images: [UIImage], completion: @escaping ([String]) -> Void) {
      let storage = Storage.storage().reference()
      var uploadedURLs: [String] = []
      let dispatchGroup = DispatchGroup()

      for image in images {
          guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
          let imageRef = storage.child("images/\(UUID().uuidString).jpg")
          dispatchGroup.enter()

          imageRef.putData(imageData, metadata: nil) { _, error in
              if let error = error {
                  print("Upload failed: \(error.localizedDescription)")
                  dispatchGroup.leave()
                  return
              }

              imageRef.downloadURL { url, error in
                  if let url = url {
                      uploadedURLs.append(url.absoluteString)
                  } else if let error = error {
                      print("Failed to get download URL: \(error.localizedDescription)")
                  }
                  dispatchGroup.leave()
              }
          }
      }

      dispatchGroup.notify(queue: .main) {
          print("All uploads completed. URLs: \(uploadedURLs)") // Debugging print
          completion(uploadedURLs)
      }
  }


  // save Listing to Firestore
  func saveListing(_ listing: Listing, completion: @escaping (Result<Void, Error>) -> Void) {
      let db = Firestore.firestore()
      do {
          try db.collection("Listings").document(listing.id).setData(from: listing) { error in
              if let error = error {
                  print("Firestore save error:", error)
                  completion(.failure(error))
              } else {
                  print("Listing successfully saved.")
                  completion(.success(()))
              }
          }
      } catch {
          print("Data serialization error:", error)
          completion(.failure(error))
      }
  }

  // save ListingDraft after images are uploaded
  func saveListingFromDraft(_ draft: ListingDraft, completion: @escaping (Result<Void, Error>) -> Void) {
      let listing = Listing(
        id: UUID().uuidString,
          title: draft.title,
          creationTime: Date(),
          description: draft.description,
          category: draft.category,
          size: draft.size,
          price: draft.price,
          color: draft.color,
          condition: draft.condition,
          photoURLs: draft.photoURLs,
          tags: draft.tags,
          brand: draft.brand,
          maxRentalDuration: draft.maxRentalDuration,
          pickupLocation: draft.pickupLocation,
          available: draft.available,
          rating: draft.rating
      )
      print("Saving listing with URLs:", listing.photoURLs)
        
      saveListing(listing, completion: completion)
  }
  
  // fetch all listings from Firestore
      func fetchListings(completion: @escaping (Result<[Listing], Error>) -> Void) {
          let db = Firestore.firestore()
          db.collection("Listings").getDocuments { snapshot, error in
              if let error = error {
                  completion(.failure(error))
                  return
              }
              
              let listings = snapshot?.documents.compactMap { document in
                  try? document.data(as: Listing.self)
              } ?? []
              completion(.success(listings))
          }
      }
      
  // delete a listing from Firestore
  func deleteListing(_ id: String, completion: @escaping (Result<Void, Error>) -> Void) {
      let db = Firestore.firestore()
      db.collection("Listings").document(id).delete { error in
          if let error = error {
              completion(.failure(error))
          } else {
              completion(.success(()))
          }
      }
  }
}



