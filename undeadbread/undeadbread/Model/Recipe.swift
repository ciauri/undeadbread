//
//  Recipe.swift
//  undeadbread
//
//  Created by stephenciauri on 8/13/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation

class Recipe {
    var name: String
    var ingredients: [Ingredient] = []
    var steps: [Step] = []
    var sections: [Section] = []
    
    struct Section {
        let title: String
        let numberOfRows: Int
    }
    
    init(named: String) {
        name = named
    }
}
