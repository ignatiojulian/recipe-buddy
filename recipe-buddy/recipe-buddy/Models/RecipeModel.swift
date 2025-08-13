//
//  RecipeModel.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation

struct RecipeModel: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    let tags: [String]
    let minutes: Int
    let image: String
    let ingredients: [IngredientModel]
    let steps: [String]
}
