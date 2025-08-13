//
//  RecipeListView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var recipeStore: RecipeStoreViewModel
    @EnvironmentObject var favoritesManager: FavoriteManager
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if recipeStore.isLoading && recipeStore.recipes.isEmpty {
                    LoadingView()
                } else if let error = recipeStore.error {
                    ErrorView(message: error) {
                        recipeStore.loadRecipes()
                    }
                } else if recipeStore.filteredRecipes.isEmpty {
                    EmptyStateView(message: "No recipes found")
                } else {
                    List {
                        ForEach(recipeStore.filteredRecipes) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                RecipeRowView(recipe: recipe)
                            }
                        }
                    }
                    .refreshable {
                        recipeStore.loadRecipes()
                    }
                }
            }
            .navigationTitle("RecipeBuddy")
            .searchable(text: $recipeStore.searchText, prompt: "Search recipes or tags")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingFilters.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterView()
            }
        }
    }
}
