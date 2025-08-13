//
//  MealPlanRowView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct MealPlanRowView: View {
    let mealPlan: MealPlanModel
    @EnvironmentObject var recipeStore: RecipeStoreViewModel
    @EnvironmentObject var mealPlanManager: MealPlanManager
    
    var recipe: RecipeModel? {
        guard let recipeId = mealPlan.recipeId else { return nil }
        return recipeStore.recipes.first { $0.id == recipeId }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(mealPlan.day)
                    .font(.headline)
                
                if let recipe = recipe {
                    Text(recipe.title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    Text("No meal planned")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            
            Spacer()
            
            if recipe != nil {
                Button(action: {
                    mealPlanManager.removeRecipe(from: mealPlan.day)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
