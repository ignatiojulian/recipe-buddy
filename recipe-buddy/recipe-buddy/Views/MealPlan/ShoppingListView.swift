//
//  ShoppingListView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var mealPlanManager: MealPlanManager
    @EnvironmentObject var recipeStore: RecipeStoreViewModel
    @Environment(\.dismiss) var dismiss
    
    var shoppingList: [(ingredient: String, quantities: [String])] {
        mealPlanManager.generateShoppingList(recipes: recipeStore.recipes)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if shoppingList.isEmpty {
                    EmptyStateView(message: "No items in shopping list")
                } else {
                    List(shoppingList, id: \.ingredient) { item in
                        HStack {
                            Image(systemName: "square")
                            VStack(alignment: .leading) {
                                Text(item.ingredient)
                                    .font(.headline)
                                Text(item.quantities.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Shopping List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
