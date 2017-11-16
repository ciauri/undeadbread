//
//  Comment.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 11/15/17.
//

import Foundation

struct Comment: Codable {
    let timestamp: Date = Date()
    var user: UserAccount?
    var postId: String?
    let text: String
}

struct CommentCollection: Codable {
    let comments: [Comment]
}
