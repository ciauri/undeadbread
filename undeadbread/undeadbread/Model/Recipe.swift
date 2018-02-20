//
//  Recipe.swift
//  undeadbread
//
//  Created by stephenciauri on 8/13/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation

struct Recipe: Codable, Named {
    var uuid: String
    var name: String
    var ingredients: [Ingredient] = []
    var rations: [Ration] = []
    var sections: [Section] = []
    
    init(name: String, ingredients: [Ingredient], rations: [Ration], sections: [Section]) {
        uuid = UUID().uuidString
        self.name = name
        self.ingredients = ingredients
        self.rations = rations
        self.sections = sections
    }
    
    init(name: String, ingredients: [Ingredient], rations: [Ration], sections: [Section], uuid: String?) {
        self.init(name: name, ingredients: ingredients, rations: rations, sections: sections)
        if let uuid = uuid {
            self.uuid = uuid
        }
    }
    
    struct Section: Codable {
        let title: String
        var steps: [Step]
    }
}

extension Recipe: Equatable {
    static func ==(lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
