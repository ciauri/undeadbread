//
//  Ingredient.swift
//  undeadbread
//
//  Created by stephenciauri on 8/12/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation

class Ingredient {
    var name: String
    
    init(named: String) {
        name = named
    }
}

extension Ingredient: CustomStringConvertible {
    var description: String {
        return name
    }
}
