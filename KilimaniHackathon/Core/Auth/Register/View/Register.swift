//
//  Register.swift
//  KilimaniHackathon
//
//  Created by Muktar Aisak on 02/08/2024.
//

import SwiftUI

struct RegisterView: View {
    @State private var showPassword: Bool = false
    
    @FocusState var firstNameIsFocused: Bool
    @FocusState var lastNameIsFocused: Bool
    @FocusState var emailIsFocused: Bool
    @FocusState var usernameIsFocused: Bool
    @FocusState var passwordIsFocused: Bool
    
    @StateObject var registerVM = RegisterVM()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Logo()
                
                Text("Create Account")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 12)
                
                Text("First Name")
                firstNameField
                
                Text("Last Name")
                lastNameField
                
                
                Text("Email")
                emailField
                
                Text("Username")
                usernameField
                
                Text("Password")
                passwordField
                
                AuthButton(title: "Create Account", action: { })
                
                HStack {
                    Rectangle()
                        .frame(width: 60, height: 1)
                    Text("Or continue with")
                    Rectangle()
                        .frame(width: 60, height: 1)
                }
                .foregroundStyle(.gray)
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .center)
                
                Image("ios_dark_sq_na")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 32)
            .padding(.horizontal)
            .onAppear {
                firstNameIsFocused = true
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    RegisterView()
}


extension RegisterView {
    
    
    private var firstNameField: some View {
        // MARK: Email
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "person")
                .foregroundStyle(.gray)
            TextField("First name", text: $registerVM.firstName)
                .textContentType(.emailAddress)
                .textContentType(.emailAddress)
                .focused($firstNameIsFocused)
                .onSubmit {
                    lastNameIsFocused = true
                }
        }
        .padding()
        .frame(height: 45)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary, lineWidth: 0.5)
        }
    }
    
    private var lastNameField: some View {
        // MARK: Email
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "person")
                .foregroundStyle(.gray)
            TextField("Last name", text: $registerVM.lastName)
                .textContentType(.emailAddress)
                .textContentType(.emailAddress)
                .focused($lastNameIsFocused)
                .onSubmit {
                    emailIsFocused = true
                }
        }
        .padding()
        .frame(height: 45)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary, lineWidth: 0.5)
        }
    }
    
    private var emailField: some View {
        // MARK: Email
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "envelope")
                .foregroundStyle(.gray)
            TextField("Email", text: $registerVM.email)
                .textContentType(.emailAddress)
                .textContentType(.emailAddress)
                .focused($emailIsFocused)
                .onSubmit {
                    usernameIsFocused = true
                }
        }
        .padding()
        .frame(height: 45)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary, lineWidth: 0.5)
        }
    }
    
    private var usernameField: some View {
        // MARK: Username
        HStack(alignment: .center, spacing: 16) {
            Image("person")
            TextField("Username", text: $registerVM.username)
                .textContentType(.name)
                .focused($usernameIsFocused)
                .onSubmit {
                    passwordIsFocused = true
                }
        }
        .padding()
        .frame(height: 45)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary, lineWidth: 0.5)
        }
    }
    
    private var passwordField: some View {
        HStack(alignment: .center, spacing: 16) {
            Image("key")
            ZStack {
                TextField("Password", text: $registerVM.password)
                    .textContentType(.password)
                    .focused($passwordIsFocused)
                    .opacity(showPassword ? 1 : 0)
                    .onSubmit {
                        passwordIsFocused = false
                    }
                
                SecureField("Password", text: $registerVM.password)
                    .textContentType(.password)
                    .focused($passwordIsFocused)
                    .opacity(showPassword ? 0 : 1)
                    .onSubmit {
                        passwordIsFocused = false
                    }
            }
            
            Image(systemName: showPassword ? "eye" : "eye.slash")
                .onTapGesture {
                    showPassword.toggle()
                }
        }
        .padding()
        .frame(height: 45)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary, lineWidth: 0.5)
        }
    }
}






