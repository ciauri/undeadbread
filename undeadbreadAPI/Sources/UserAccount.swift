//
//  UserAccount.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/20/17.
//

import Foundation
import Turnstile
import TurnstileCrypto

struct UserAccount: Account, Codable {
    var uniqueID: String = UUID().uuidString
    
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = BCrypt.hash(password: password)
    }
}
