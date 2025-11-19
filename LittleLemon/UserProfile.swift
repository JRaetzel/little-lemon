//
//  UserProfile.swift
//  LittleLemon
//
//  Created by John Raetzel on 11/19/25.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    
    private var firstName: String {
        UserDefaults.standard.string(forKey: kFirstName) ?? ""
    }
    private var lastName: String {
        UserDefaults.standard.string(forKey: kLastName) ?? ""
    }
    private var email: String {
        UserDefaults.standard.string(forKey: kEmail) ?? ""
    }
    
    var body: some View {
        ZStack {
            LittleLemonColors.surfaceGray
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Personal information")
                    .font(LittleLemonFonts.heroTitle(32))
                    .foregroundColor(LittleLemonColors.primaryGreen)
                
                HStack(spacing: 16) {
                    Image("profile-image-placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(firstName) \(lastName)")
                            .font(LittleLemonFonts.body(18))
                            .foregroundColor(LittleLemonColors.textDark)
                        
                        Text(email)
                            .font(LittleLemonFonts.body(14))
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("First name: \(firstName)")
                    Text("Last name:  \(lastName)")
                    Text("Email:      \(email)")
                }
                .font(LittleLemonFonts.body())
                .foregroundColor(LittleLemonColors.textDark)
                
                Button(action: logout) {
                    Text("Logout")
                        .font(LittleLemonFonts.body(18))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LittleLemonColors.primaryGreen)
                        .cornerRadius(10)
                }
                .padding(.top, 24)
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func logout() {
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: kIsLoggedIn)
        presentation.wrappedValue.dismiss()
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
