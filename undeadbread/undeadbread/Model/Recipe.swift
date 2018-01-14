//
//  Recipe.swift
//  undeadbread
//
//  Created by stephenciauri on 8/13/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation

struct Recipe: Codable {
    var name: String
    var ingredients: [Ingredient] = []
    var steps: [Step] = []
    var sections: [Section] = []
    
    struct Section: Codable {
        let title: String
        let numberOfRows: Int
    }
}
