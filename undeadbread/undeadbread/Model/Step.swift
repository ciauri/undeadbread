//
//  Step.swift
//  undeadbread
//
//  Created by stephenciauri on 8/13/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation

struct Step: Codable {
    static let massFormatter = MassFormatter()
    var instructions: String = ""
    var rations: [Ration] = []
    
}

extension Step: CustomStringConvertible {
    var description: String {
        return String(format: instructions, arguments: rations.map({$0.description}))
    }
}


