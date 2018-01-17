//
//  Ingredient.swift
//  undeadbread
//
//  Created by stephenciauri on 8/12/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation

struct Ingredient: Codable {
    var name: String
    var recipe: Recipe?
}

struct Ration: Codable {
    private static let formatter: MeasurementFormatter = MeasurementFormatter()
    
    static let acceptableMasses: [UnitMass] = [.milligrams, .grams, .kilograms, .ounces, .pounds]
    static let acceptableVolumes: [UnitVolume] = [.milliliters, .centiliters, .deciliters, .liters, .teaspoons, .tablespoons, .fluidOunces, .cups, .pints, .quarts, .gallons, .bushels]
    
    let amount: Measurement<Unit>
    let ingredient: Ingredient
}

extension Ingredient: CustomStringConvertible {
    var description: String {
        return name
    }
}

extension Ration: CustomStringConvertible {
    var description: String {
        return "\(Step.massFormatter.string(fromValue: amount.value, unit: MassFormatter.Unit.gram)) of \(ingredient)"
    }
    
    var formattedAmountAndUnit: String {
        return Ration.formatter.string(from: amount)
    }
}

