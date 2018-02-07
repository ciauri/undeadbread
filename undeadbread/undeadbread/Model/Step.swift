//
//  Step.swift
//  undeadbread
//
//  Created by stephenciauri on 8/13/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation
import UIKit

struct Step: Codable {
    var instructions: String = ""
    var rations: [Ration] = []
    var imageURL: URL?
}

extension Step: CustomStringConvertible {
    var description: String {
        return String(format: instructions, arguments: rations.map({$0.description}))
    }
}


