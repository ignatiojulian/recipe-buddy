//
//  MealPlanModel.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation

struct MealPlanModel: Codable, Identifiable {
    var id = UUID()
    let day: String
    var recipeId: String?
}
