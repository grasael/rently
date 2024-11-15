//
//  rentlyApp.swift
//  rently
//
//  Created by Grace Liao on 10/26/24.
//

import SwiftUI
@_implementationOnly import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct rentlyApp: App {
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
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
                    listings: ["list1", "list2"],
                    likedItems: ["item1", "item2"],
                    styleChoices: ["vintage", "formal"],
                    events: ["event1", "event2"]
                ))
                .environmentObject(ListingsViewModel()) // Pass your environment object
                ContentView() // Use ContentView as the main view
            }
        }
    }
}

