//
//  Loaf.swift
//  undeadbread
//
//  Created by stephenciauri on 8/14/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation
import UIKit

class Loaf {
    var name: String
    var recipe: Recipe
    var date: Date
    var ratings: [Rating] = []
    var images: [UIImage] = []

    
    init(named: String, using recipe: Recipe, on date: Date) {
        name = named
        self.recipe = recipe
        self.date = date
    }
}
