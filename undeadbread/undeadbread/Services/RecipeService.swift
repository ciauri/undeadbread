//
//  RecipeService.swift
//  undeadbread
//
//  Created by stephenciauri on 2/8/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import Foundation

protocol IngredientServiceProtocol {
    func add(ingredient: Ingredient)
}

class RecipeService {
    // MARK: - Singleton
    static let shared = RecipeService()
    private init() {}
    
    var ingredientDelegate: IngredientServiceProtocol?

    // MARK: - Data
    private(set) var recipes: [Recipe] = []
    
    // MARK: - Mutator
    func add(recipe: Recipe) {
        for ingredient in recipe.ingredients + recipe.rations.map({$0.ingredient}) {
            ingredientDelegate?.add(ingredient: ingredient)
        }
        if !recipes.contains(where: {$0.name == recipe.name}) {
            recipes.append(recipe)
        }
    }
}
