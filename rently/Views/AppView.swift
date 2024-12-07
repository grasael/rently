//
//  AppView.swift
//  rently
//
//  Created by Grace Liao on 10/27/24.
//

import SwiftUI

struct AppView: View {
    @StateObject var viewModel: UserViewModel
    @State private var searchText: String = ""
    @StateObject var listingsViewModel = ListingsViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("home")
                }
                .tag(0)
            
            SearchView(searchText: $searchText)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("search")
                }
                .tag(1)
            
            MakeListingView(selectedTab: $selectedTab)
                .environmentObject(listingsViewModel)
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "plus")
                    Text("list")
                }
                .tag(2)
            
            RentalsView()
                .tabItem {
                    Image(systemName: "hanger")
                    Text("rentals")
                }
                .tag(3)
            
            ProfileView(userViewModel: viewModel)
                .tabItem {
                    Image(systemName: "person")
                    Text("profile")
                }
                .tag(4)
        }
    }
}
