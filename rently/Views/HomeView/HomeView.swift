//
//  HomeView.swift
//  rently
//
//  Created by Grace Liao on 10/27/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var searchViewModel = SearchViewModel() // Initialize SearchViewModel
    @State private var searchText: String = "" // Track search input
    @State private var isSearching = false // Track if search is active
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Search Bar
                    SearchBarView(searchText: $searchText)
                        .onTapGesture {
                            isSearching = true // When search bar is tapped, start search
                        }
                    
                    // Conditional Content
                    if !isSearching {
                        VStack(spacing: 30) {
                            ActiveRentalsView()
                            SuggestedItemsView()
                            TrendingSearchesView()
                            Spacer()
                        }
                    } else {
                        // Triggering the search view with the current search text
                        NavigationLink(destination: SearchView(searchText: $searchText), isActive: $isSearching) {
                            EmptyView()
                        }
                    }
                }
                .padding(.horizontal)
                .onAppear {
                    searchViewModel.fetchListings()
                    searchViewModel.fetchUsers()
                }
                .navigationBarHidden(true)
            }
        }
    }
}
