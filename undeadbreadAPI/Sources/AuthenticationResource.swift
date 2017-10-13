//
//  AuthenticationResource.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/11/17.
//

import Foundation
import PerfectHTTP
import PerfectLib
//import PerfectCrypto
import JWT

class AuthenticationResource {
    // MARK: - Routes
    // MARK: Root Routes
    static let registerRoute = Route(method: .post, uri: "/register", handler: registrationHandler)
    static let tokenRoute = Route(method: .post, uri: "/token", handler: tokenHandler)
    
    
    // MARK: - Route Handlers
    
    
    /// Registration Endpoint
    ///
    /// - Parameters:
    ///   - request: HTTPRequest that must provide Basic authentication
    ///   - response: successful response will contain an access token, refresh token, and expiration
    class func registrationHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.cacheControl, value: "no-store")
        response.setHeader(.pragma, value: "no-cache")
        
        guard let authorization = request.header(.authorization),
            let basicIndex = authorization.range(of: "Basic ", options: .backwards)?.upperBound,
            let decodedBytes = String(authorization[basicIndex...]).decode(.base64),
            let decodedString = String(bytes: decodedBytes, encoding: .utf8) else {
            response.completed(status: .badRequest)
            return
        }
        
        let exp = ExpirationTimeClaim(createTimestamp: { () -> Seconds in
            return Int(Date().timeIntervalSince1970) + 60
        })
        guard let jwtlol = try? JWT(payload: JSON([exp]), signer: HS256(key: "secret".bytes)),
            let token = try? jwtlol.createToken() else {
                response.completed(status: .internalServerError)
                return
        }

        NSLog("\(decodedString) - \(token)")
        let refreshToken = UUID().uuidString
        try? response.appendBody(encodable: Token(accessToken: token, refreshToken: refreshToken, expiresIn: 60*30))
        response.completed(status: .created)
    }
    
    
    /// Endpoint for issuing a refreshed access token
    ///
    /// - Parameters:
    ///   - request: HTTPRequest
    ///   - response: HTTPResponse
    class func tokenHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.cacheControl, value: "no-store")
        response.setHeader(.pragma, value: "no-cache")
        

        // Validate refresh token provided in request
        // Create and return new access token
        try? response.appendBody(encodable: Token(accessToken: "yolo", refreshToken: nil, expiresIn: 60))
        response.completed(status: .created)
    }
    
    
}

extension AuthenticationResource: Resource {
    class var routes: [Route] {
        return [registerRoute, tokenRoute]
    }
    class var rootRoutes: [Route] {
        return [registerRoute, tokenRoute]
    }
}
