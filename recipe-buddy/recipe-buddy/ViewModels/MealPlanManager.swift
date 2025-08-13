//
//  MealPlanManager.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation

@MainActor
class MealPlanManager: ObservableObject {
    @Published var mealPlans: [MealPlanModel] = []
    
    let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    private let mealPlansKey = "meal_plans"
    
    init() {
        loadMealPlans()
        if mealPlans.isEmpty {
            initializeMealPlans()
        }
    }
    
    func initializeMealPlans() {
        mealPlans = weekDays.map { MealPlanModel(day: $0, recipeId: nil) }
        saveMealPlans()
    }
    
    func assignRecipe(_ recipeId: String, to day: String) {
        if let index = mealPlans.firstIndex(where: { $0.day == day }) {
            mealPlans[index].recipeId = recipeId
            saveMealPlans()
        }
    }
    
    func removeRecipe(from day: String) {
        if let index = mealPlans.firstIndex(where: { $0.day == day }) {
            mealPlans[index].recipeId = nil
            saveMealPlans()
        }
    }
    
    func generateShoppingList(recipes: [RecipeModel]) -> [(ingredient: String, quantities: [String])] {
        var ingredientMap: [String: [String]] = [:]
        
        for plan in mealPlans {
            if let recipeId = plan.recipeId,
               let recipe = recipes.first(where: { $0.id == recipeId }) {
                for ingredient in recipe.ingredients {
                    if ingredientMap[ingredient.name] == nil {
                        ingredientMap[ingredient.name] = []
                    }
                    ingredientMap[ingredient.name]?.append(ingredient.quantity)
                }
            }
        }
        
        return ingredientMap.map { (ingredient: $0.key, quantities: $0.value) }.sorted { $0.ingredient < $1.ingredient }
    }
    
    private func saveMealPlans() {
        if let encoded = try? JSONEncoder().encode(mealPlans) {
            UserDefaults.standard.set(encoded, forKey: mealPlansKey)
        }
    }
    
    private func loadMealPlans() {
        guard let data = UserDefaults.standard.data(forKey: mealPlansKey),
              let plans = try? JSONDecoder().decode([MealPlanModel].self, from: data) else {
            return
        }
        mealPlans = plans
    }
}
