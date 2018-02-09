//
//  IngredientService.swift
//  undeadbread
//
//  Created by stephenciauri on 2/8/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import Foundation

class IngredientService: IngredientServiceProtocol {
    // MARK: - Singleton
    static let shared = IngredientService()
    private init() {}
    
    // MARK: - Data
    private(set) var ingredients: [Ingredient] = []
    
    // MARK: - Mutator
    func add(ingredient: Ingredient) {
        if !ingredients.contains(where: {$0.name == ingredient.name}) {
            ingredients.append(ingredient)
        }
    }
    

}
