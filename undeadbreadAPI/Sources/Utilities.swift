//
//  Utilities.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/11/17.
//

import Foundation
import PerfectHTTP
import JWT

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

extension HTTPRequest {
    var jwt: JWT? {
        guard let authHeader = self.header(.authorization),
            let range = authHeader.range(of: "Bearer ") else {
                return nil
        }
        // Parse token
        let token = authHeader.substring(from: range.upperBound)
        // Attempt to create jwt
        return try? JWT(token: token)
    }
}
