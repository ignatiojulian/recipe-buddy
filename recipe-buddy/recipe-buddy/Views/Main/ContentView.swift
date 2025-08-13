//
//  ContentView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipeListView()
                .tabItem {
                    Label("Recipes", systemImage: "book")
                }
                .tag(0)
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(1)
            
            MealPlanView()
                .tabItem {
                    Label("Meal Plan", systemImage: "calendar")
                }
                .tag(2)
        }
    }
}
