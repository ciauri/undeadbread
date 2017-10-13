//
//  Step.swift
//  undeadbread
//
//  Created by stephenciauri on 8/13/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation

class Step {
    static let massFormatter = MassFormatter()
    var instructions: String = ""
    var rations: [Ration] = []
    
    struct Ration{
        let amount: Measurement<Unit>
        let ingredient: Ingredient
    }
}

extension Step: CustomStringConvertible {
    var description: String {
        return String(format: instructions, arguments: rations.map({$0.description}))
    }
}

extension Step.Ration: CustomStringConvertible {
    var description: String {
        return "\(Step.massFormatter.string(fromValue: amount.value, unit: MassFormatter.Unit.gram)) of \(ingredient)"
    }
}
