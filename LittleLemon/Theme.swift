//
//  Theme.swift
//  LittleLemon
//
//  Created by John Raetzel on 11/19/25.
//

import SwiftUI

struct LittleLemonColors {
    static let primaryGreen  = Color(red: 73/255,  green: 94/255,  blue: 87/255)   // #495E57
    static let primaryYellow = Color(red: 244/255, green: 206/255, blue: 20/255)   // #F4CE14
    static let secondaryPeach = Color(red: 238/255, green: 153/255, blue: 114/255) // #EE9972
    static let secondaryLight = Color(red: 251/255, green: 218/255, blue: 187/255) // #FBDABB
    static let surfaceGray   = Color(red: 237/255, green: 239/255, blue: 238/255) // #EDEFEE
    static let textDark      = Color(red: 51/255,  green: 51/255,  blue: 51/255)  // #333333
}

struct LittleLemonFonts {
    // These font names assume you’ve added Markazi Text & Karla to your project.
    // If not, SwiftUI will fall back silently.
    static func heroTitle(_ size: CGFloat = 42) -> Font {
        .custom("MarkaziText-Medium", size: size)
    }
    
    static func heroSubtitle(_ size: CGFloat = 24) -> Font {
        .custom("MarkaziText-Medium", size: size)
    }
    
    static func body(_ size: CGFloat = 16) -> Font {
        .custom("Karla-Regular", size: size)
    }
}
