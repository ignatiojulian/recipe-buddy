//
//  FavoritesView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var recipeStore: RecipeStoreViewModel
    @EnvironmentObject var favoritesManager: FavoriteManager
    
    var favoriteRecipes: [RecipeModel] {
        recipeStore.recipes.filter { favoritesManager.isFavorite($0.id) }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if favoriteRecipes.isEmpty {
                    EmptyStateView(message: "No favorite recipes yet")
                } else {
                    List(favoriteRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                            RecipeRowView(recipe: recipe)
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
