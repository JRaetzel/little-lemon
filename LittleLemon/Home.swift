//
//  Home.swift
//  LittleLemon
//
//  Created by John Raetzel on 11/19/25.
//

import SwiftUI
import CoreData

struct Home: View {
    let persistence = PersistenceController.shared
    
    var body: some View {
        TabView {
            Menu()
                .environment(\.managedObjectContext,
                              persistence.container.viewContext)
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            
            UserProfile()
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .accentColor(LittleLemonColors.primaryYellow)
        .navigationBarBackButtonHidden(true)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.shared
        Home()
            .environment(\.managedObjectContext,
                          persistence.container.viewContext)
    }
}
