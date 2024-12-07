//
//  SearchView.swift
//  rently
//
//  Created by Grace Liao on 10/27/24.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String // Accepting a binding from the parent view
    
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header with Logo and Filter Icon
            HStack {
                Text("rently")
                    .font(.largeTitle)
                    .foregroundColor(Color.blue.opacity(0.7))
                    .bold()
                Spacer()
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            
            // Search Bar with binding to searchText
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("search for anything...", text: $searchText)
                    .padding(8)
                    .onChange(of: searchText) { newValue in
                        viewModel.filterListingsAndUsers(query: newValue)
                    }
            }
            .background(Color(UIColor.systemGray5))
            .cornerRadius(16)
            .padding(.horizontal)
            
            // Show relevant results based on search query
            if !searchText.isEmpty {
                List {
                    Section(header: Text("Listings")) {
                        ForEach(viewModel.listings) { listing in
                            NavigationLink(destination: ListingView(listing: listing)) {
                                HStack {
                                    AsyncImage(url: URL(string: listing.photoURLs.first ?? "")) { phase in
                                        if let image = phase.image {
                                            image.resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                        } else if phase.error != nil {
                                            Image(systemName: "xmark.circle")
                                                .frame(width: 50, height: 50)
                                        } else {
                                            ProgressView()
                                                .frame(width: 50, height: 50)
                                        }
                                    }
                                    VStack(alignment: .leading) {
                                        Text(listing.title)
                                            .font(.headline)
                                        Text("$\(listing.price, specifier: "%.2f")")
                                            .font(.subheadline)
                                    }
                                }
                            }
                        }
                    }
                    Section(header: Text("Users")) {
                        ForEach(viewModel.users) { user in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(user.firstName) \(user.lastName)")
                                        .font(.headline)
                                    Text("@\(user.username)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
            } else {
                // Default view with categories and seasonal sections
                Text("shop by category")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        CategoryIcon(name: "tops", iconURL: URL(string: "https://cdn-icons-png.flaticon.com/512/4267/4267723.png")!) {
                            searchForCategory("tops")
                        }
                        CategoryIcon(name: "bottoms", iconURL: URL(string: "https://cdn-icons-png.flaticon.com/512/808/808726.png")!) {
                            searchForCategory("bottoms")
                        }
                        CategoryIcon(name: "outerwear", iconURL: URL(string: "https://images.vexels.com/media/users/3/142974/isolated/preview/804b58e4b241aec0a4fa8a9b6fe22e41-stroke-striped-jacket-clothing.png")!) {
                            searchForCategory("outerwear")
                        }
                        CategoryIcon(name: "dresses", iconURL: URL(string: "https://icons.veryicon.com/png/o/internet--web/website-common-icons/dress-122.png")!) {
                            searchForCategory("dresses")
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Seasonal Sections
                ScrollView {
                    VStack(spacing: 12) {
                        SeasonalSection(imageURL: URL(string: "https://sc-cms-prod103-cdn-dsb5cvath4adbgd0.z01.azurefd.net/-/media/images/astoncarter/insights/articles/gettyimages1443303360-jpg.jpg?rev=78cdd90832394584b7570407c585f1e8")!, title: "interview season")
                        SeasonalSection(imageURL: URL(string: "https://media.istockphoto.com/id/1388581317/photo/figure-skating-lady-is-wearing-black-sportswear-is-skating-on-ice-rink-training-at-night-in.jpg?s=612x612&w=0&k=20&c=KFjeMcUvYbaYvcYEUBgz5rzpjMBfCtKvgdV57Dv_pMs=")!, title: "winter break")
                        SeasonalSection(imageURL: URL(string: "https://assets.editorial.aetnd.com/uploads/2009/11/halloween-gettyimages-1424736925.jpg")!, title: "halloween")
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchListings()
            viewModel.fetchUsers()
        }
    }
    
    // Helper method to handle category search
    private func searchForCategory(_ category: String) {
        searchText = category
        viewModel.filterListingsAndUsers(query: searchText)
    }
}



// Updated CategoryIcon to include an action
struct CategoryIcon: View {
    let name: String
    let iconURL: URL
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                } placeholder: {
                    ProgressView()
                        .frame(width: 60, height: 60)
                }
                Text(name)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

// Placeholder for SeasonalSection View
struct SeasonalSection: View {
    let imageURL: URL
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: imageURL) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } placeholder: {
                ProgressView()
                    .frame(height: 150)
            }
            Text(title)
                .font(.headline)
                .padding(.top, 5)
        }
    }
}
