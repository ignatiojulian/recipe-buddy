//
//  SharesheetView.swift
//  recipe-buddy
//
//  Created by Ignatio Julian on 13/08/25.
//

import Foundation
import SwiftUI

struct ShareSheetView: UIViewControllerRepresentable {
    let recipe: RecipeModel
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let text = """
        Check out this recipe: \(recipe.title)
        
        Time: \(recipe.minutes) minutes
        
        Ingredients:
        \(recipe.ingredients.map { "• \($0.name): \($0.quantity)" }.joined(separator: "\n"))
        
        Instructions:
        \(recipe.steps.enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: "\n"))
        """
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
