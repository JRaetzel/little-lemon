//
//  DishDetail.swift
//  LittleLemon
//
//  Created by John Raetzel on 11/19/25.
//

import SwiftUI

struct DishDetail: View {
    let dish: Dish    // Coming from CoreData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // MARK: Dish Image
                if let urlString = dish.image,
                   let url = URL(string: urlString) {
                    
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Color.gray.opacity(0.2)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(height: 250)
                    .clipped()
                    
                } else {
                    // Fallback if image missing
                    Color.gray.opacity(0.2)
                        .frame(height: 250)
                        .overlay(
                            Text("No image")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                }
                
                // MARK: Dish Title
                Text(dish.title ?? "Unnamed Dish")
                    .font(LittleLemonFonts.heroTitle(32))
                    .foregroundColor(LittleLemonColors.primaryGreen)
                    .padding(.horizontal)
                
                // MARK: Category
                if let category = dish.category {
                    Text(category.capitalized)
                        .font(LittleLemonFonts.body(14))
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                // MARK: Price
                Text("$\(dish.price ?? "0")")
                    .font(LittleLemonFonts.body(22))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // MARK: Placeholder description
                Text("This is one of our signature dishes, prepared with fresh ingredients using authentic Mediterranean techniques. Enjoy a flavorful taste of Little Lemon!")
                    .font(LittleLemonFonts.body(16))
                    .foregroundColor(LittleLemonColors.textDark)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                Spacer()
            }
        }
        .navigationTitle(dish.title ?? "Dish Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DishDetail_Previews: PreviewProvider {
    static var previews: some View {
        Text("Preview requires a Dish instance from Core Data.")
            .padding()
    }
}
