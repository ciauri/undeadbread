//
//  AuthenticationFilter.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/12/17.
//

import Foundation
import TurnstilePerfect
import Turnstile
import PerfectHTTP
import JWT

struct UDBAuthFilter: HTTPRequestFilter {
    var authenticationConfig = AuthenticationConfig()
    
    init(_ cfg: AuthenticationConfig) {
        authenticationConfig = cfg
    }
    
    func filter(request: HTTPRequest, response: HTTPResponse, callback: (HTTPRequestFilterResult) -> ()) {
        var checkAuth = false
        let wildcardInclusions = authenticationConfig.inclusions.filter({$0.contains("*")})
        let wildcardExclusions = authenticationConfig.exclusions.filter({$0.contains("*")})
        
        // check if specifically in inclusions
        if authenticationConfig.inclusions.contains(request.path) { checkAuth = true }
        // check if covered by a wildcard
        for wInc in wildcardInclusions {
            if request.path.startsWith(wInc.split("*")[0]) { checkAuth = true }
        }
        
        // ignore check if specified in exclusions
        if authenticationConfig.exclusions.contains(request.path) { checkAuth = false }
        // check if covered by a wildcard
        for wExc in wildcardExclusions {
            if request.path.startsWith(wExc.split("*")[0]) { checkAuth = false }
        }
        
        if checkAuth {
            if authorize(request: request) /* authenticated */ {
                callback(.continue(request, response))
                return
            } else {
                response.status = .unauthorized
                callback(.halt(request, response))
            }
        } else {
            callback(.continue(request, response))
        }
    }
    
    func authorize(request: HTTPRequest) -> Bool {
        // Parse header
        guard let authHeader = request.header(.authorization),
            let range = authHeader.range(of: "Bearer ") else {
                return false
        }
        // Parse token
        let token = authHeader.substring(from: range.upperBound)
        // Attempt to create jwt
        guard let jwt = try? JWT(token: token) else {
            return false
        }
        do {
            // Validate payload signature matches hash signed with secret and validate token not expired
            try jwt.verifySignature(using: HS256(key: UndeadBreadAPI.shared.signingSecret.bytes))
            guard let date = jwt.payload[ExpirationTimeClaim.name]?.date,
                ExpirationTimeClaim(date: Date()).verify(Node(date.timeIntervalSince1970)) else {
                    throw IncorrectCredentialsError()
            }
        } catch {
            return false
        }
        return true
    }
}

