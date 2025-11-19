//
//  Onboarding.swift
//  LittleLemon
//
//  Created by John Raetzel on 11/19/25.
//

import SwiftUI

struct Onboarding: View {
    @State private var firstName: String = ""
    @State private var lastName: String  = ""
    @State private var email: String     = ""
    @State private var isLoggedIn: Bool  = false
    
    // 0, 1, 2 = onboarding pages
    @State private var pageIndex: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                LittleLemonColors.primaryGreen
                    .ignoresSafeArea()
                
                VStack {
                    // Navigation to Home after registration
                    NavigationLink(
                        destination: Home(),
                        isActive: $isLoggedIn
                    ) { EmptyView() }
                    .hidden()
                    
                    // Logo
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                        .padding(.top, 24)
                    
                    Spacer()
                    
                    // Card with pages
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // PAGE CONTENT
                        if pageIndex == 0 {
                            pageOne
                        } else if pageIndex == 1 {
                            pageTwo
                        } else {
                            pageThreeRegistration
                        }
                        
                        // PAGE INDICATORS
                        HStack(spacing: 6) {
                            ForEach(0..<3) { idx in
                                Circle()
                                    .fill(idx == pageIndex ?
                                          LittleLemonColors.primaryGreen :
                                          LittleLemonColors.surfaceGray)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.top, 4)
                        
                        // BUTTON ROW
                        HStack {
                            if pageIndex > 0 {
                                Button("Back") {
                                    withAnimation {
                                        pageIndex -= 1
                                    }
                                }
                                .font(LittleLemonFonts.body(16))
                            }
                            
                            Spacer()
                            
                            if pageIndex < 2 {
                                Button("Next") {
                                    withAnimation {
                                        pageIndex += 1
                                    }
                                }
                                .font(LittleLemonFonts.body(16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(LittleLemonColors.primaryYellow)
                                .cornerRadius(8)
                                .foregroundColor(LittleLemonColors.textDark)
                            } else {
                                Button(action: registerUser) {
                                    Text("Register")
                                        .font(LittleLemonFonts.body(18))
                                        .fontWeight(.semibold)
                                        .foregroundColor(LittleLemonColors.textDark)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(LittleLemonColors.primaryYellow)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(.top, 4)
                    }
                    .padding(24)
                    .background(LittleLemonColors.surfaceGray)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
            .onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedIn = true
                }
            }
        }
    }
    
    // MARK: - Page views
    
    private var pageOne: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Welcome to")
                .font(LittleLemonFonts.body(18))
                .foregroundColor(LittleLemonColors.textDark)
            
            Text("Little Lemon")
                .font(LittleLemonFonts.heroTitle(40))
                .foregroundColor(LittleLemonColors.textDark)
            
            Text("A family-owned Mediterranean restaurant in the heart of Chicago.")
                .font(LittleLemonFonts.body(16))
                .foregroundColor(LittleLemonColors.textDark)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var pageTwo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order quickly")
                .font(LittleLemonFonts.heroSubtitle(28))
                .foregroundColor(LittleLemonColors.textDark)
            
            Text("Browse the menu, search for your favorite dishes, and explore our specials.")
                .font(LittleLemonFonts.body(16))
                .foregroundColor(LittleLemonColors.textDark)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Save your details once and we’ll remember you next time.")
                .font(LittleLemonFonts.body(16))
                .foregroundColor(LittleLemonColors.textDark)
        }
    }
    
    private var pageThreeRegistration: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Create your profile")
                .font(LittleLemonFonts.heroSubtitle(28))
                .foregroundColor(LittleLemonColors.textDark)
            
            Text("Enter your details so we can personalize your experience.")
                .font(LittleLemonFonts.body(16))
                .foregroundColor(LittleLemonColors.textDark)
            
            VStack(spacing: 12) {
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                #if os(iOS)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                #else
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                #endif
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
    }
    
    // MARK: - Register
    
    private func registerUser() {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty
        else { return }
        
        let defaults = UserDefaults.standard
        defaults.set(firstName, forKey: kFirstName)
        defaults.set(lastName,  forKey: kLastName)
        defaults.set(email,     forKey: kEmail)
        defaults.set(true,      forKey: kIsLoggedIn)
        
        isLoggedIn = true
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
