//
//  SignUpForm.swift
//  Whispaw
//
//  Created by ebowwa-mac-13inch on 6/17/24.
//
import SwiftUI

struct SignUpForm: View {
    @Binding var username: String
    @Binding var email: String
    @Binding var password: String

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
}
