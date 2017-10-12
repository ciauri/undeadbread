//
//  AuthenticationFilter.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/12/17.
//

import Foundation
import PerfectHTTP
import JWT

struct AccessTokenFilter: HTTPRequestFilter {
    
    
    /// Filter for authenticated requests requiring an access token
    ///
    /// - Parameters:
    ///   - request: The request that should contain an access_token in it's body
    ///   - response: HTTPResponse
    ///   - callback: Callback executed after the filter has determined the next action
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        // TODO: Build a way to specify which routes should be filtered at the main.swift level
        guard let token = request.param(name: "access_token") else {
            callback(.halt(request, response))
            return
        }
        validate(token: token) { (success) in
            if success {
                callback(.continue(request, response))
            } else {
                callback(.halt(request, response))
            }
        }
    }
    
    
    /// Validates the JWT
    ///
    /// - Parameters:
    ///   - token: The token in string form
    ///   - completion: Block returning true if validated
    func validate(token: String, completion: (Bool)->()) {
        guard let jwt = try? JWT(token: token) else {
            completion(false)
            return
        }
        do {
            // TODO: Verify everything
            try jwt.verifySignature(using: HS256(key: "secret".bytes))
            try jwt.verifyClaims([ExpirationTimeClaim(createTimestamp: { () -> Seconds in
                return Int(Date().timeIntervalSince1970) + 60
            })])
        } catch {
            completion(false)
            return
        }
        
        completion(true)
    }
}
