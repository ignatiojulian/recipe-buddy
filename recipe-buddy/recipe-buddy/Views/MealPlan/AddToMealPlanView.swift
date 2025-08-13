//
//  AddToMealPlanView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct AddToMealPlanView: View {
    let recipe: RecipeModel
    @EnvironmentObject var mealPlanManager: MealPlanManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(mealPlanManager.weekDays, id: \.self) { day in
                Button(action: {
                    mealPlanManager.assignRecipe(recipe.id, to: day)
                    dismiss()
                }) {
                    HStack {
                        Text(day)
                        Spacer()
                        if let plan = mealPlanManager.mealPlans.first(where: { $0.day == day }),
                           plan.recipeId == recipe.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
            .navigationTitle("Select Day")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
