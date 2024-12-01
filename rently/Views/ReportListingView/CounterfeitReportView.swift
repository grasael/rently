//
//  CounterfeitReportView.swift
//  rently
//
//  Created by Grace Liao on 11/28/24.
//

import Foundation
import SwiftUI

struct CounterfeitReportView: View {
    @State private var additionalDetails: String = ""
    @Environment(\.presentationMode) var presentationMode // For dismissing the current view

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Navigate back
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("report")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Spacer()
            }
            .padding([.horizontal, .top])

            VStack(alignment: .leading, spacing: 8) {
                Text("counterfeit item")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("any fraudulent imitation of a product bearing a trademark without the owner's consent")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            VStack(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        .frame(height: 150)

                    if additionalDetails.isEmpty {
                        Text("please provide more details (optional)")
                            .foregroundColor(.pink)
                            .font(.subheadline)
                            .padding(.top, 8)
                            .padding(.horizontal, 8)
                    }

                    TextEditor(text: $additionalDetails)
                        .padding(8)
                        .frame(height: 150)
                        .background(Color.clear)
                        .opacity(1)
                }
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                print("Send button tapped with details: \(additionalDetails)")
            }) {
                Text("send")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.green.opacity(0.6)]),
                               startPoint: .leading,
                               endPoint: .trailing)
            )
            .cornerRadius(8)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationBarHidden(true)
        .background(Color(UIColor.systemBackground))
    }
}

struct CounterfeitReportView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CounterfeitReportView()
        }
    }
}