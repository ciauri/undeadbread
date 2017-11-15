//
//  UserAccount.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/20/17.
//

import Foundation
import Turnstile
import TurnstileCrypto
import JWT

struct UserAccount: Account, Codable {
    static var users: [String:UserAccount] = [:]
    static var refreshTokenMap: [String:UserAccount] = [:]
    
    static func registerUser(username: String, password: String) -> UserAccount? {
        guard users.values.array.first(where: {$0.username == username}) == nil else {
            return nil
        }
        let userAccount = UserAccount(username: username, password: password)
        users[userAccount.uniqueID] = userAccount
        return userAccount
    }
    
    static func authenticate(with jwt: JWT) -> UserAccount? {
        if let userId = jwt.payload["sub"]?.string,
            let account = users[userId] {
            return account
        } else {
            return nil
        }
    }
    
    static func authenticate(withRefreshToken refreshToken: String) -> UserAccount? {
        return refreshTokenMap[refreshToken]
    }
    
    static func authenticate(username: String, password: String) -> UserAccount? {
        guard let user = users.values.array.first(where: {$0.username == username}) else {
            return nil
        }
        if let verified = try? BCrypt.verify(password: password, matchesHash: user.password),
            verified == true {
            return user
        } else {
            return nil
        }
    }

    var uniqueID: String = UUID().uuidString
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = BCrypt.hash(password: password)
    }
}
