//
//  PerfectHelpers.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/11/17.
//

import Foundation
import PerfectHTTP
import PerfectLib

extension HTTPResponse {
    func appendBody<T: Encodable>(encodable object: T) throws {
        let encoded = try UndeadBreadAPI.shared.jsonEncoder.encode(object)
        guard let encodedString = String(data: encoded, encoding: .utf8) else {
            throw JSONConversionError.notConvertible(encoded)
        }
        appendBody(string: encodedString)
    }
}
extension Route {
    var absoluteURLString: String {
        return UndeadBreadAPI.shared.baseURL.absoluteString.appending("\(self.uri)")
    }
}
