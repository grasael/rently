//
//  MakeListingView.swift
//  rently
//
//  Created by Abby Chen on 11/2/24.
//

import SwiftUI
import PhotosUI

struct ListingDraft: Codable {
    var title: String = ""
    var description: String = ""
    var category: String = Category.womensTops.rawValue
    var brand: String = ""
    var condition: String = ""
    var photoURLs: [String] = []
    var size: String = ItemSize.xxsmall.rawValue
    var price: Double = 0.0
    var color: String = ItemColor.red.rawValue
    var tags: [String] = []
    var maxRentalDuration: String = RentalDuration.oneWeek.rawValue
    var pickupLocation: String = PickupLocation.uc.rawValue
    var available: Bool = true
    var rating: Float = 0.0
    var creationTime: Date = Date()
}


struct MakeListingView: View {
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var viewModel: ListingsViewModel
  
  @State private var draft = ListingDraft()
  
  // photo selection
  @State private var selectedImages: [PhotosPickerItem?] = Array(repeating: nil, count: 4)
  @State private var uploadedImages: [UIImage?] = Array(repeating: nil, count: 4)
  
  let user: User
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          // cancel button
          HStack {
            Button(action: {
              presentationMode.wrappedValue.dismiss()
            }) {
              Image(systemName: "xmark")
                .font(.title2)
                .padding(10)
            }
            Spacer()
          }
          
          // page title
          Text("make a listing")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .bold()
          
          // upload photos
          Text("upload photos (max 4):")
            .font(.system(size: 16))
          
          // placeholders for up to 4 photos
          LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
              ForEach(0..<4, id: \.self) { index in
                  if index < uploadedImages.count, let image = uploadedImages[index] {
                      // show the uploaded image
                      Image(uiImage: image)
                          .resizable()
                          .scaledToFill()
                          .frame(width: 80, height: 80)
                          .clipShape(RoundedRectangle(cornerRadius: 10))
                          .overlay(
                              RoundedRectangle(cornerRadius: 10)
                                  .stroke(Color.black, lineWidth: 1)
                          )
                          .onTapGesture {
                              showPhotoPicker(for: index)
                          }
                  } else {
                      // show a PhotosPicker for this slot
                      PhotosPicker(selection: Binding(
                          get: { selectedImages[index] },
                          set: { selectedImages[index] = $0 }
                      ), matching: .images) {
                          ZStack {
                              RoundedRectangle(cornerRadius: 10)
                                  .stroke(Color.black, lineWidth: 1)
                                  .frame(width: 80, height: 80)
                              Image(systemName: "plus")
                                  .foregroundColor(.gray)
                          }
                      }
                      .onChange(of: selectedImages[index]) { newItem in
                          loadSelectedPhoto(for: index, from: newItem)
                      }
                  }
              }
          }
        
          // add title
          TextField("title", text: $draft.title)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
            )
          
          // add description
          ZStack(alignment: .topLeading) {
            ZStack {
              Color.white
                .cornerRadius(8)
              
              TextEditor(text: $draft.description)
                .frame(height: 100)
                .padding(4)
                .background(Color.clear)
                .cornerRadius(8)
                .overlay(
                  RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: 1)
                )
            }
            
            if draft.description.isEmpty {
              Text("description: max 200 words")
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
          }
          
          // category and color
          HStack {
            // category
            Picker("category", selection: Binding(
              get: {
                  Category(rawValue: draft.category) ?? .womensTops
              },
              set: {
                  draft.category = $0.rawValue
              }
          )) {
              ForEach(Category.allCases, id: \.self) { category in Text(category.rawValue).tag(category)
              }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
            )
            
            // color
            Picker("color", selection: Binding(
              get: {
                  ItemColor(rawValue: draft.color) ?? .red
              },
              set: {
                  draft.color = $0.rawValue
              }
          )) {
              ForEach(ItemColor.allCases, id: \.self) {
                color in Text(color.rawValue).tag(color)
              }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
            )
          }
          
          // brand
          TextField("brand", text: $draft.brand)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
            )
          
          // condition
          Text("condition: ")
            .font(.system(size: 16))
          HStack {
            ForEach(["brand new", "very good", "good", "fair"], id: \.self) { conditionOption in Button(action: {
              draft.condition = conditionOption
            }) {
              Text(conditionOption)
                .padding(9)
                .background(draft.condition == conditionOption ? Color.gray.opacity(0.9) : Color.gray.opacity(0.4))
                .cornerRadius(20)
                .foregroundColor(.white)
            }
            }
          }
          
          // size and price
          HStack {
            // size
            Picker("size", selection: Binding(
              get: {
                  ItemSize(rawValue: draft.size) ?? .xxsmall
              },
              set: {
                  draft.size = $0.rawValue
              }
          )) {
              ForEach(ItemSize.allCases, id: \.self) { size in Text(size.rawValue).tag(size)
              }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1)
            )
            
            // price
            TextField("price", text: Binding(
              get: { String(draft.price) },
              set: { draft.price = Double($0) ?? 0 }
            ))
              .padding(.vertical, 10)
              .padding(.horizontal, 8)
              .background(Color.white)
              .cornerRadius(8)
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(Color.black, lineWidth: 1)
              )
            
            Text("/ day")
              .padding(.leading, 4)
          }
          
          // tags
          Text("tags (max 3):")
              .font(.system(size: 16))
          LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {
              ForEach(TagOption.allCases, id: \.self) { tag in
                  Button(action: {
                    if draft.tags.contains(tag.rawValue) {
                      draft.tags.removeAll { $0 == tag.rawValue }
                    } else if draft.tags.count < 3 {
                      draft.tags.append(tag.rawValue)
                      }
                  }) {
                      Text(tag.rawValue)
                          .padding(.vertical, 8)
                          .padding(.horizontal, 12)
                          .frame(minWidth: 100)
                          .lineLimit(1)
                          .background(draft.tags.contains(tag.rawValue) ? Color("MediumGreen") : Color("LightGreen"))
                          .foregroundColor(.white)
                          .cornerRadius(20)
                  }
                  .disabled(draft.tags.count >= 3 && !draft.tags.contains(tag.rawValue))
              }
          }
          .padding(.bottom, 10)
          
          Rectangle()
            .fill(Color.gray.opacity(0.4))
            .frame(height: 1)
          
          
          // next button
          NavigationLink(destination: MakeListingTwoView(user: user, draft: $draft)) {
              Text("next")
                  .font(.system(size: 22))
                  .foregroundColor(.white)
                  .padding(.vertical, 8)
                  .padding(.horizontal, 40)
                  .background(
                      LinearGradient(
                          gradient: Gradient(colors: [Color("MediumBlue"), Color("PaleGreen")]),
                          startPoint: .leading,
                          endPoint: .trailing
                      )
                  )
                  .cornerRadius(25)
                  .shadow(radius: 5)
          }
          .simultaneousGesture(TapGesture().onEnded {
              uploadImagesAndContinue {
                FirebaseService.shared.saveListingFromDraft(draft) { result in
                        switch result {
                        case .success:
                            print("Draft saved successfully: \(draft)")
                        case .failure(let error):
                            print("Failed to save draft: \(error.localizedDescription)")
                        }
                    }
              }
          })
          .frame(maxWidth: 200)
          .frame(maxWidth: .infinity)
          .padding(.top)
        }
        .padding(.top, -20)
        .padding(.horizontal, 20)
      }
    }
  }
  
  func showPhotoPicker(for index: Int) {
      PhotosPicker(selection: Binding(
          get: { selectedImages[index] },
          set: { selectedImages[index] = $0 }
      ), matching: .images) {
          ZStack {
              RoundedRectangle(cornerRadius: 10)
                  .stroke(Color.black, lineWidth: 1)
                  .frame(width: 80, height: 80)
              Image(systemName: "plus")
                  .foregroundColor(.gray)
          }
      }
      .onChange(of: selectedImages[index]) { newItem in
          loadSelectedPhoto(for: index, from: newItem)
      }
  }
  
  func loadSelectedPhoto(for index: Int, from item: PhotosPickerItem?) {
      guard let item = item else { return }
      Task {
          if let data = try? await item.loadTransferable(type: Data.self),
             let image = UIImage(data: data) {
              if uploadedImages.count > index {
                  uploadedImages[index] = image
              } else {
                  while uploadedImages.count <= index {
                      uploadedImages.append(nil)
                  }
                  uploadedImages[index] = image
              }
          }
      }
  }

  func uploadImagesAndContinue(completion: @escaping () -> Void) {
      let nonNilImages = uploadedImages.compactMap { $0 }
      
      if nonNilImages.isEmpty {
          print("No images to upload")
          draft.photoURLs = []
          completion()
          return
      }
      
      FirebaseService.shared.uploadImages(nonNilImages) { urls in
          draft.photoURLs = urls
          print("Uploaded URLs: \(urls)")
          completion() // proceed after URLs are set
      }
  }

}

/*#Preview {
    MakeListingView(user: User(
      id: "123",
              firstName: "Abby",
              lastName: "Chen",
              username: "abbychen",
              pronouns: "she/her",
              email: "abby@example.com",
              password: "password123",
              university: "CMU",
              rating: 4.8,
              listings: ["list1", "list2"], // Example Listing IDs
              likedItems: ["item1", "item2"], // Example Liked Item IDs
              styleChoices: ["vintage", "formal"],
              events: ["event1", "event2"]
          ))
}*/
