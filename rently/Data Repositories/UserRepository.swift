
//
//  UserRepository.swift
//  rently
//
//  Created by Grace Liao on 11/7/24.
//

import Foundation
import Combine
import FirebaseFirestore

class UserRepository: ObservableObject {
  private let path: String = "Users"
  private let store = Firestore.firestore()
  @Published var users: [User] = []
  private var cancellables: Set<AnyCancellable> = []
  init() {
    self.get()
  }
    
    func get() {
        store.collection(path)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting users: \(error.localizedDescription)")
                    return
                }
                self.users = querySnapshot?.documents.compactMap { document in
                    var user = try? document.data(as: User.self)
                    user?.id = document.documentID // Explicitly set the document ID
                    return user
                } ?? []
            }
    }
  // MARK: CRUD methods
  func create(_ user: User, completion: @escaping (String?) -> Void) {
          do {
              let documentReference = try store.collection(path).addDocument(from: user)
              let documentID = documentReference.documentID
              print("✅ User added to Firestore with ID: \(documentID)")
              var newUser = user
              newUser.id = documentID
                    
              // Save the user to UserManager
              UserManager.shared.saveUser(newUser)
              
              completion(documentID)
          } catch {
              print("❌ Error adding user to Firestore: \(error)")
              completion(nil)
          }
      }
  func update(_ user: User) {
          print("USER ID is \(user.id)")
          guard let userId = user.id else {
              print("Error: User ID is nil. Update aborted.")
              return
          }
          do {
              try store.collection(path).document(userId).setData(from: user)
              UserManager.shared.saveUser(user)
              print("✅ User successfully updated.")
          } catch {
              print("Unable to update user: \(error.localizedDescription).")
          }
      }
  
  func delete(_ user: User) {
      guard let userId = user.id else { return }
      
      store.collection(path).document(userId).delete { error in
        if let error = error {
          print("Unable to remove user: \(error.localizedDescription)")
        }
      }
    }
      
    // Add a follower
    func addFollower(to userID: String, followerID: String) {
        let userRef = store.collection(path).document(userID)
        userRef.updateData([
            "followers": FieldValue.arrayUnion([followerID])
        ]) { error in
            if let error = error {
                print("Error adding follower: \(error.localizedDescription)")
            } else {
                print("Follower added successfully to user \(userID).")
            }
        }
    }
    // Remove a follower
    func removeFollower(from userID: String, followerID: String) {
        let userRef = store.collection(path).document(userID)
        userRef.updateData([
            "followers": FieldValue.arrayRemove([followerID])
        ]) { error in
            if let error = error {
                print("Error removing follower: \(error.localizedDescription)")
            } else {
                print("Follower removed successfully from user \(userID).")
            }
        }
    }
    // Add to following
    func addFollowing(for userID: String, followingID: String) {
        let userRef = store.collection(path).document(userID)
        userRef.updateData([
            "following": FieldValue.arrayUnion([followingID])
        ]) { error in
            if let error = error {
                print("Error adding to following: \(error.localizedDescription)")
            } else {
                print("Following added successfully for user \(userID).")
            }
        }
    }
    // Remove from following
    func removeFollowing(for userID: String, followingID: String) {
        let userRef = store.collection(path).document(userID)
        userRef.updateData([
            "following": FieldValue.arrayRemove([followingID])
        ]) { error in
            if let error = error {
                print("Error removing from following: \(error.localizedDescription)")
            } else {
                print("Following removed successfully for user \(userID).")
            }
        }
    }
    
    func fetchUsers(withIDs userIDs: [String], completion: @escaping ([User]) -> Void) {
        var fetchedUsers: [User] = []
        let dispatchGroup = DispatchGroup()
        for userID in userIDs {
            dispatchGroup.enter()
            store.collection(path).document(userID).getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error fetching user with ID \(userID): \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                guard let document = documentSnapshot, document.exists else {
                    print("No document found for user with ID \(userID)")
                    dispatchGroup.leave()
                    return
                }
                do {
                    // Decode the document into a User
                    var user = try document.data(as: User.self)
                    // Assign the document ID explicitly to the user's ID
                    user.id = document.documentID
                    // Append the user to the fetchedUsers array
                    fetchedUsers.append(user)
                } catch {
                    print("Error decoding user with ID \(userID): \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(fetchedUsers)
        }
    }
    
    func fetchUser(byEmail email: String, completion: @escaping (User?) -> Void) {
        print("🔍 Fetching user by email: \(email)") // Debug
        store.collection(path)
            .whereField("email", isEqualTo: email)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("❌ Firestore fetch error: \(error.localizedDescription)") // Debug
                    completion(nil)
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    print("❌ No document found for email: \(email)") // Debug
                    completion(nil)
                    return
                }
                
                do {
                    var user = try document.data(as: User.self)
                    user.id = document.documentID // Explicitly set the ID
                    print("✅ Fetched user document: \(user)") // Debug
                    completion(user)
                } catch {
                    print("❌ Error decoding user document: \(error.localizedDescription)") // Debug
                    completion(nil)
                }
            }
    }
}
