//
//  RecipeService.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation

// MARK: - Service Protocol
protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [RecipeModel]
    func fetchRecipe(by id: String) async throws -> RecipeModel?
    func searchRecipes(query: String) async throws -> [RecipeModel]
    func fetchRecipesByTag(_ tag: String) async throws -> [RecipeModel]
}

// MARK: - Service Errors
enum RecipeServiceError: LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(String)
    case cacheError
    case recipeNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Failed to decode recipe data"
        case .networkError(let message):
            return "Network error: \(message)"
        case .cacheError:
            return "Failed to access cached data"
        case .recipeNotFound:
            return "Recipe not found"
        }
    }
}

// MARK: - Recipe Service Implementation
class RecipeService: RecipeServiceProtocol {
    private let networkManager: NetworkManager
    private let cacheManager: CacheManager
    private let baseURL = "https://api.recipebuddy.com" // Replace with actual API
    
    // Cache keys
    private let recipesCacheKey = "cached_recipes"
    private let cacheExpirationKey = "cache_expiration"
    private let cacheExpirationInterval: TimeInterval = 3600 // 1 hour
    
    static let shared = RecipeService()
    
    init(networkManager: NetworkManager = NetworkManager.shared,
         cacheManager: CacheManager = CacheManager.shared) {
        self.networkManager = networkManager
        self.cacheManager = cacheManager
    }
    
    // MARK: - Public Methods
    
    func fetchRecipes() async throws -> [RecipeModel] {
        if let cachedRecipes = loadCachedRecipes(), !isCacheExpired() {
            print("📱 Loading recipes from cache")
            return cachedRecipes
        }
        
        do {
            print("🌐 Fetching recipes from network")
            let recipes = try await fetchRecipesFromNetwork()
            
            cacheRecipes(recipes)
            
            return recipes
        } catch {
            if let cachedRecipes = loadCachedRecipes() {
                print("⚠️ Network failed, using cached data")
                return cachedRecipes
            }
            
            throw error
        }
    }
    
    func fetchRecipe(by id: String) async throws -> RecipeModel? {
        if let cachedRecipes = loadCachedRecipes() {
            if let recipe = cachedRecipes.first(where: { $0.id == id }) {
                return recipe
            }
        }
        
        guard let url = URL(string: "\(baseURL)/recipes/\(id)") else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let recipe: RecipeModel = try await networkManager.fetch(from: url)
            return recipe
        } catch {
            throw RecipeServiceError.networkError(error.localizedDescription)
        }
    }
    
    func searchRecipes(query: String) async throws -> [RecipeModel] {
        let allRecipes = try await fetchRecipes()
        
        let searchResults = allRecipes.filter { recipe in
            recipe.title.localizedCaseInsensitiveContains(query) ||
            recipe.tags.contains { $0.localizedCaseInsensitiveContains(query) }
        }
        
        return searchResults
    }
    
    func fetchRecipesByTag(_ tag: String) async throws -> [RecipeModel] {
        let allRecipes = try await fetchRecipes()
        
        return allRecipes.filter { recipe in
            recipe.tags.contains { $0.localizedCaseInsensitiveContains(tag) }
        }
    }
    
    // MARK: - Private Methods
    
    private func fetchRecipesFromNetwork() async throws -> [RecipeModel] {
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return try getMockRecipes()
    }
    
    private func getMockRecipes() throws -> [RecipeModel] {
        let recipesJSON = """
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
        """
        
        guard let data = recipesJSON.data(using: .utf8) else {
            throw RecipeServiceError.noData
        }
        
        do {
            let recipes = try JSONDecoder().decode([RecipeModel].self, from: data)
            return recipes
        } catch {
            throw RecipeServiceError.decodingError
        }
    }
    
    // MARK: - Cache Management
    
    private func cacheRecipes(_ recipes: [RecipeModel]) {
        cacheManager.save(recipes, forKey: recipesCacheKey)
        cacheManager.save(Date(), forKey: cacheExpirationKey)
    }
    
    private func loadCachedRecipes() -> [RecipeModel]? {
        return cacheManager.load([RecipeModel].self, forKey: recipesCacheKey)
    }
    
    private func isCacheExpired() -> Bool {
        guard let expirationDate = cacheManager.load(Date.self, forKey: cacheExpirationKey) else {
            return true
        }
        
        return Date().timeIntervalSince(expirationDate) > cacheExpirationInterval
    }
    
    func clearCache() {
        cacheManager.remove(forKey: recipesCacheKey)
        cacheManager.remove(forKey: cacheExpirationKey)
    }
}
