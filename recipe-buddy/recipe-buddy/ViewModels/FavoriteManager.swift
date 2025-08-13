//
//  FavoriteManager.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation

@MainActor
class FavoriteManager: ObservableObject {
    @Published var favoriteIds: Set<String> = []
    
    private let favoritesKey = "favorite_recipe_ids"
    
    init() {
        loadFavorites()
    }
    
    func toggleFavorite(_ recipeId: String) {
        if favoriteIds.contains(recipeId) {
            favoriteIds.remove(recipeId)
        } else {
            favoriteIds.insert(recipeId)
        }
        
        saveFavorites()
    }
    
    func isFavorite(_ recipeId: String) -> Bool {
        favoriteIds.contains(recipeId)
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteIds), forKey: favoritesKey)
    }
    
    private func loadFavorites() {
        if let savedIds = UserDefaults.standard.stringArray(forKey: favoritesKey) {
            favoriteIds = Set(savedIds)
        }
    }
}
