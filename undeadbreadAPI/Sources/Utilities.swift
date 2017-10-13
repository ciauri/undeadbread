//
//  Utilities.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/11/17.
//

import Foundation

// MARK: - Makes dealing with json/optionals much cleaner
extension String {
    var intValue: Int? {
        return Int(self)
    }
    
    var floatValue: Float? {
        return Float(self)
    }
    
    var doubleValue: Double? {
        return Double(self)
    }
    
    var urlValue: URL? {
        return URL(string: self)
    }
}
