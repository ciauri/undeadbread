//
//  Serialization.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/11/17.
//

import Foundation
import PerfectHTTP

protocol Entity: Codable {
    var links: [String:URL] { get }
    var href: URL { get }
}

protocol Resource {
    static var routes: [Route] { get }
    static var rootRoutes: [Route] { get }
}

struct Token: Codable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case type = "token_type"
        case expiresIn = "expires_in"
    }
    let accessToken: String
    let refreshToken: String?
    let type: String = "bearer"
    let expiresIn: Int
}
