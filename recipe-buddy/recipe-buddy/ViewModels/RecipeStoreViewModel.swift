//
//  RecipeStoreViewModel.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import Combine

@MainActor
class RecipeStoreViewModel: ObservableObject {
    @Published var recipes: [RecipeModel] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText = ""
    @Published var selectedTag: String?
    @Published var sortOption: SortOption = .none
    
    enum SortOption: String, CaseIterable {
        case none = "Default"
        case titleAsc = "Title (A-Z)"
        case titleDesc = "Title (Z-A)"
        case timeAsc = "Time (Low-High)"
        case timeDesc = "Time (High-Low)"
    }
    
    var filteredRecipes: [RecipeModel] {
        var result = recipes
        
        // Search filter
        if !searchText.isEmpty {
            result = result.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Tag filter
        if let tag = selectedTag {
            result = result.filter { $0.tags.contains(tag) }
        }
        
        // Sorting
        switch sortOption {
        case .none:
            break
        case .titleAsc:
            result.sort { $0.title < $1.title }
        case .titleDesc:
            result.sort { $0.title > $1.title }
        case .timeAsc:
            result.sort { $0.minutes < $1.minutes }
        case .timeDesc:
            result.sort { $0.minutes > $1.minutes }
        }
        
        return result
    }
    
    var allTags: [String] {
        Array(Set(recipes.flatMap { $0.tags })).sorted()
    }
    
    init() {
        loadRecipes()
    }
    
    func loadRecipes() {
        isLoading = true
        error = nil
        
        // Check for cached data first (offline-first)
        if let cachedRecipes = loadCachedRecipes() {
            self.recipes = cachedRecipes
            isLoading = false
        }
        
        // Simulate network request with provided data
        Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5 second delay
                
                let recipesData = """
                [
                  {
                    "id": "r1",
                    "title": "Garlic Lemon Chicken",
                    "tags": ["quick", "protein"],
                    "minutes": 25,
                    "image": "https://picsum.photos/seed/r1/600/400",
                    "ingredients": [
                      { "name": "Chicken breast", "quantity": "300 g" },
                      { "name": "Garlic", "quantity": "3 cloves" },
                      { "name": "Lemon", "quantity": "1 pc" },
                      { "name": "Olive oil", "quantity": "2 tbsp" },
                      { "name": "Salt", "quantity": "to taste" },
                      { "name": "Pepper", "quantity": "to taste" }
                    ],
                    "steps": [
                      "Marinate chicken with garlic, lemon juice, salt, pepper.",
                      "Pan sear with olive oil until cooked through.",
                      "Rest 2 minutes, slice, and serve."
                    ]
                  },
                  {
                    "id": "r2",
                    "title": "Veggie Pasta Primavera",
                    "tags": ["vegetarian", "family"],
                    "minutes": 30,
                    "image": "https://picsum.photos/seed/r2/600/400",
                    "ingredients": [
                      { "name": "Pasta", "quantity": "200 g" },
                      { "name": "Broccoli", "quantity": "1 cup" },
                      { "name": "Bell pepper", "quantity": "1 pc" },
                      { "name": "Cherry tomatoes", "quantity": "10 pcs" },
                      { "name": "Parmesan", "quantity": "30 g" }
                    ],
                    "steps": [
                      "Boil pasta until al dente.",
                      "Sauté veggies lightly, season well.",
                      "Combine pasta and veggies, finish with parmesan."
                    ]
                  },
                  {
                    "id": "r3",
                    "title": "Overnight Oats",
                    "tags": ["breakfast", "quick"],
                    "minutes": 10,
                    "image": "https://picsum.photos/seed/r3/600/400",
                    "ingredients": [
                      { "name": "Rolled oats", "quantity": "1/2 cup" },
                      { "name": "Milk", "quantity": "1/2 cup" },
                      { "name": "Yogurt", "quantity": "1/4 cup" },
                      { "name": "Honey", "quantity": "1 tbsp" },
                      { "name": "Berries", "quantity": "1/3 cup" }
                    ],
                    "steps": [
                      "Mix oats, milk, yogurt, honey in a jar.",
                      "Refrigerate overnight.",
                      "Top with berries before serving."
                    ]
                  }
                ]
                """.data(using: .utf8)!
                
                let decodedRecipes = try JSONDecoder().decode([RecipeModel].self, from: recipesData)
                self.recipes = decodedRecipes
                self.cacheRecipes(decodedRecipes)
                self.isLoading = false
            } catch {
                self.error = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func cacheRecipes(_ recipes: [RecipeModel]) {
        if let encoded = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(encoded, forKey: "cached_recipes")
        }
    }
    
    private func loadCachedRecipes() -> [RecipeModel]? {
        guard let data = UserDefaults.standard.data(forKey: "cached_recipes"),
              let recipes = try? JSONDecoder().decode([RecipeModel].self, from: data) else {
            return nil
        }
        return recipes
    }
}
