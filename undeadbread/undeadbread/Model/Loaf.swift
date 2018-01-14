//
//  Loaf.swift
//  undeadbread
//
//  Created by stephenciauri on 8/14/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation
import UIKit

struct Loaf: Codable {
    var name: String
    var recipe: Recipe
    var date: Date
    var ratings: [Rating] = []
    var images: [URL] = []
}
