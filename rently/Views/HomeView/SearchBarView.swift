//
//  SearchBarView.swift
//  rently
//
//  Created by Tishyaa Chaudhry on 11/2/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String // Binding for searchText from parent
    
    var body: some View {
        HStack {
            TextField("Search for an item...", text: $searchText)
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(8)
    }
}
