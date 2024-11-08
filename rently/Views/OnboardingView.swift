//
//  OnboardingView.swift
//  rently
//
//  Created by Grace Liao on 11/4/24.
//

import SwiftUI

struct OnboardingView: View {
    var onboardingComplete: (User) -> Void
    
    @State private var name = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var pronouns = ""
    @State private var email = ""
    @State private var password = ""
    @State private var university = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showSuccessAlert = false
    @State private var navigateToProfile = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Let's get you started")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                Divider()
                
                TextField("First Name", text: $name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Pronouns", text: $pronouns)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("University", text: $university)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)

                Button(action: signUp) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(8)
                .padding(.horizontal)
                
                Spacer()
                
                // Navigation link to ProfileView
//                NavigationLink(destination: ProfileView(user: User(firstName: name, lastName: lastName, username: username, pronouns: pronouns, email: email, password: password, university: university, rating: 0, listings: [], likedItems: [], styleChoices: [], events: [])), isActive: $navigateToProfile) {
//                    EmptyView()
//                }
            }
            .padding()
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("You have successfully signed up!"),
                    dismissButton: .default(Text("Continue")) {
                        // Create the new user object and pass it to ContentView
                                            let newUser = User(
                                                firstName: name,
                                                lastName: lastName,
                                                username: username,
                                                pronouns: pronouns,
                                                email: email,
                                                password: password,
                                                university: university,
                                                rating: 0,
                                                listings: [],
                                                likedItems: [],
                                                styleChoices: [],
                                                events: []
                                            )
                                            onboardingComplete(newUser)
                        // Create a UserViewModel instance to handle adding the user
                        let userViewModel = UserViewModel(user: newUser)
                        userViewModel.addUser()
                    }
                )
            }
        }
    }
    
    private func signUp() {
        guard !name.isEmpty, !lastName.isEmpty, !username.isEmpty, !pronouns.isEmpty, !email.isEmpty, !password.isEmpty, !university.isEmpty else {
            errorMessage = "Please fill out all fields."
            showErrorAlert = true
            return
        }

        // Create a User instance with the collected data
//        let newUser = User(
//            firstName: name,
//            lastName: lastName,
//            username: username,
//            pronouns: pronouns,
//            email: email,
//            password: password,
//            university: university,
//            rating: 0,
//            listings: [],
//            likedItems: [],
//            styleChoices: [],
//            events: []
//        )

        // Show success alert
        showSuccessAlert = true
    }
}