//
//  OnboardingView.swift
//  rently
//
//  Created by Grace Liao on 11/4/24.
//

import SwiftUI
import Combine

struct OnboardingView: View {
    var email: String
    var university: String
    @ObservedObject var userViewModel: UserViewModel

    @State private var name = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var pronouns = ""
    @State private var password = ""
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showSuccessAlert = false
    @State private var agreeToTerms = false
    @State private var cancellables = Set<AnyCancellable>()
    @State private var navigateToAppView = false

    var body: some View {
        VStack(spacing: 20) {
            Text("let's get you set up")
                .font(.title2)
                .fontWeight(.medium)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("username: *")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)

                TextField("", text: $username)
                    .padding(8)
                    .font(.system(size: 14))
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .autocapitalization(.none)

                Text("No special characters or spaces")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)

                Text("first name: *")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)

                TextField("", text: $name)
                    .padding(8)
                    .font(.system(size: 14))
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text("last name:")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)

                TextField("", text: $lastName)
                    .padding(8)
                    .font(.system(size: 14))
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Text("pronouns: *")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)

                TextField("", text: $pronouns)
                    .padding(8)
                    .font(.system(size: 14))
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )

                Text("password: *")
                    .foregroundColor(.black)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)

                SecureField("", text: $password)
                    .padding(8)
                    .font(.system(size: 14))
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                VStack(alignment: .leading, spacing: 4) {
                    Text("• 8 characters or more")
                    Text("• At least 1 number")
                    Text("• At least 1 letter")
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
            }
            .padding(.horizontal)

            HStack {
                Toggle(isOn: $agreeToTerms) {
                    HStack(spacing: 4) {
                        Text("I agree with")
                        Button("terms of use") {
                            // Add action for showing terms of use here
                        }
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            .padding(.horizontal)
            .font(.system(size: 12))

            Button(action: signUp) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 40)
                    .font(.system(size: 16, weight: .semibold))
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.green]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(8)
            .padding(.horizontal)
        }
        .padding()
        .fullScreenCover(isPresented: $navigateToAppView) {
            AppView(viewModel: userViewModel)
                .onDisappear {
                    navigateToAppView = false
                }
        }
        .padding()
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Success"),
                message: Text("You have successfully signed up!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func signUp() {
        guard !name.isEmpty, !username.isEmpty, !pronouns.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill out all fields."
            showErrorAlert = true
            return
        }
        
        userViewModel.user.firstName = name
        userViewModel.user.lastName = lastName
        userViewModel.user.username = username
        userViewModel.user.pronouns = pronouns
        userViewModel.user.password = password
        userViewModel.user.email = email
        userViewModel.user.university = university

        userViewModel.addUser()

        userViewModel.$user
            .compactMap { $0.id }
            .first()
            .sink { id in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.navigateToAppView = true
                }
            }
            .store(in: &cancellables)
    }
}
