//
//  UserViewModel.swift
//  rently
//
//  Created by Grace Liao on 11/1/24.
//

import Foundation
import Combine

class UserViewModel: ObservableObject, Identifiable {
    private let userRepository = UserRepository()
    @Published var user: User
    private var cancellables: Set<AnyCancellable> = []
    var id = ""

    init(user: User) {
        self.user = user
        print("🔍 Initializing UserViewModel with user ID: \(user.id ?? "nil")")
        $user
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }

    func addUser() {
        userRepository.create(user)
    }

    func updateUser() {
        print("Updating user with ID: \(user.id ?? "no ID")")
        print("Current user data: \(user)")
        userRepository.update(user)
    }

    func deleteUser() {
        userRepository.delete(user)
    }
}
