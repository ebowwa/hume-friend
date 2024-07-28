//
//  UserModel.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/17/24.
//

import Foundation

struct User: Codable {
    var id: UUID
    var username: String
    var email: String
    var isLoggedIn: Bool

    // You can add more fields as needed, such as password, name, etc.

    // Initialize a new user
    init(username: String, email: String, isLoggedIn: Bool = false) {
        self.id = UUID()
        self.username = username
        self.email = email
        self.isLoggedIn = isLoggedIn
    }

    // Function to save the user data to UserDefaults
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }

    // Static function to load the user data from UserDefaults
    static func load() -> User? {
        if let savedUser = UserDefaults.standard.object(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(User.self, from: savedUser) {
                return loadedUser
            }
        }
        return nil
    }

    // Function to log the user in
    mutating func login() {
        self.isLoggedIn = true
        self.save()
    }

    // Function to log the user out
    mutating func logout() {
        self.isLoggedIn = false
        self.save()
    }
}
