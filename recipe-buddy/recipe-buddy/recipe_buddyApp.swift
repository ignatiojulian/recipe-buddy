//
//  recipe_buddyApp.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import SwiftUI

@main
struct recipe_buddyApp: App {
    
    @StateObject private var recipeStore = RecipeStoreViewModel()
    @StateObject private var favoritesManager = FavoriteManager()
    @StateObject private var mealPlanManager = MealPlanManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(recipeStore)
                .environmentObject(favoritesManager)
                .environmentObject(mealPlanManager)
        }
    }
}
