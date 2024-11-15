//
//  ListingsViewModel.swift
//  rently
//
//  Created by Abby Chen on 11/2/24.
//

import Foundation
import Combine

class ListingsViewModel: ObservableObject {
    @Published var listings: [Listing] = []
    
    init() {
        fetchListings() // Load listings when the ViewModel is initialized
    }

    // Add a new listing to Firebase and the local listings array
    func addListing(_ listing: Listing) {
        FirebaseService.shared.saveListing(listing) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.listings.append(listing)
                }
                print("Listing added successfully.")
            case .failure(let error):
                print("Failed to save listing: \(error.localizedDescription)")
            }
        }
    }
    
    // Fetch listings from Firebase
    func fetchListings() {
        FirebaseService.shared.fetchListings { result in
            switch result {
            case .success(let fetchedListings):
                DispatchQueue.main.async {
                    self.listings = fetchedListings
                }
            case .failure(let error):
                print("Failed to fetch listings: \(error.localizedDescription)")
            }
        }
    }
    
    // Edit a listing in Firebase and update the local listings array
    func editListing(_ listing: Listing) {
        // Find index of the listing to edit
        if let index = listings.firstIndex(where: { $0.id == listing.id }) {
            // Update listing in Firebase
            FirebaseService.shared.saveListing(listing) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.listings[index] = listing
                    }
                    print("Listing updated successfully.")
                case .failure(let error):
                    print("Failed to update listing: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Delete a listing from Firebase and remove it from the local listings array
    func deleteListing(_ listing: Listing) {
      FirebaseService.shared.deleteListing(listing.id) { result in
          switch result {
          case .success:
              DispatchQueue.main.async {
                  self.listings.removeAll { $0.id == listing.id }
              }
              print("Listing deleted successfully.")
          case .failure(let error):
              print("Failed to delete listing: \(error.localizedDescription)")
          }
      }
  }

    private var repository = ListingRepository()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        repository.$listings
            .assign(to: \.listings, on: self)
            .store(in: &cancellables)
    }

    func fetchListings() {
        repository.fetchListings()
    }
    
    var listingsCount: Int {
        return listings.count
    }
    
    // CRUD will go here later
}

