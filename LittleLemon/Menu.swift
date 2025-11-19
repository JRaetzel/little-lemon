//
//  Menu.swift
//  LittleLemon
//
//  Created by John Raetzel on 11/19/25.
//

import SwiftUI
import CoreData

struct Menu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "all"  // all, starters, mains, desserts
    
    private let menuURL = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
    
    var body: some View {
        VStack(spacing: 0) {
            // HEADER + HERO
            headerAndHero
            
            // CATEGORY BAR
            categoryBar
            
            // MENU LIST
            FetchedObjects(
                predicate: buildPredicate(),
                sortDescriptors: buildSortDescriptors()
            ) { (dishes: [Dish]) in
                List {
                    ForEach(dishes, id: \.self) { dish in
                        NavigationLink(destination: DishDetail(dish: dish)) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dish.title ?? "")
                                        .font(LittleLemonFonts.body(18))
                                        .foregroundColor(LittleLemonColors.textDark)
                                    
                                    Text("$\(dish.price ?? "")")
                                        .font(LittleLemonFonts.body(14))
                                        .foregroundColor(.secondary)
                                    
                                    if let category = dish.category {
                                        Text(category.capitalized)
                                            .font(LittleLemonFonts.body(12))
                                            .foregroundColor(LittleLemonColors.primaryGreen)
                                    }
                                }
                                
                                Spacer()
                                
                                if let urlString = dish.image,
                                   let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 70, height: 70)
                                    .clipped()
                                    .cornerRadius(10)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .background(LittleLemonColors.surfaceGray.ignoresSafeArea())
        .onAppear {
            getMenuData()
        }
        .navigationTitle("Little Lemon")
    }
    
    // MARK: - Header & Hero
    
    private var headerAndHero: some View {
        ZStack {
            LittleLemonColors.primaryGreen
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Little Lemon")
                            .font(LittleLemonFonts.heroTitle(40))
                            .foregroundColor(LittleLemonColors.primaryYellow)
                        Text("Chicago")
                            .font(LittleLemonFonts.heroSubtitle(28))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Image("Hero image")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipped()
                        .cornerRadius(16)
                }
                
                Text("We are a family-owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                    .font(LittleLemonFonts.body(14))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Search bar inside hero section
                #if os(iOS)
                TextField("Search menu", text: $searchText)
                    .keyboardType(.default)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                #else
                TextField("Search menu", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                #endif
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Category bar
    
    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                categoryChip(title: "All", value: "all")
                categoryChip(title: "Starters", value: "starters")
                categoryChip(title: "Mains", value: "mains")
                categoryChip(title: "Desserts", value: "desserts")
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(LittleLemonColors.surfaceGray)
    }
    
    private func categoryChip(title: String, value: String) -> some View {
        Button {
            selectedCategory = value
        } label: {
            Text(title)
                .font(LittleLemonFonts.body(14))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selectedCategory == value ? LittleLemonColors.primaryYellow : Color.white)
                .foregroundColor(LittleLemonColors.textDark)
                .cornerRadius(20)
        }
    }
    
    // MARK: - Sorting & Filtering
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare)
            )
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        var predicates: [NSPredicate] = []
        
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedSearch.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", trimmedSearch))
        }
        
        if selectedCategory != "all" {
            predicates.append(NSPredicate(format: "category ==[cd] %@", selectedCategory))
        }
        
        if predicates.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
    // MARK: - Network & Core Data
    
    func getMenuData() {
        PersistenceController.shared.clear()
        
        guard let url = URL(string: menuURL) else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil, let data = data else { return }
            
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(MenuList.self, from: data) {
                DispatchQueue.main.async {
                    for item in decoded.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.image = item.image
                        dish.price = item.price
                        dish.category = item.category
                    }
                    try? viewContext.save()
                }
            }
        }
        task.resume()
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        let persistence = PersistenceController.shared
        NavigationView {
            Menu()
                .environment(\.managedObjectContext,
                              persistence.container.viewContext)
        }
    }
}
