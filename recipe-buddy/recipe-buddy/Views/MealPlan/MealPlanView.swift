//
//  MealPlanView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct MealPlanView: View {
    @EnvironmentObject var mealPlanManager: MealPlanManager
    @EnvironmentObject var recipeStore: RecipeStoreViewModel
    @State private var showingShoppingList = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(mealPlanManager.mealPlans) { plan in
                    MealPlanRowView(mealPlan: plan)
                }
            }
            .navigationTitle("Weekly Meal Plan")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingShoppingList = true
                    }) {
                        Label("Shopping List", systemImage: "cart")
                    }
                }
            }
            .sheet(isPresented: $showingShoppingList) {
                ShoppingListView()
            }
        }
    }
}
