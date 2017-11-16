//
//  Post.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 11/15/17.
//

import Foundation

struct Post: Codable {
    // Keyed on the Post uuid
    static var posts: [String:Post] = [:]
    static var commentMap: [String:[Comment]] = [:]

    var href: URL?
    var links: [String:URL]?
    let uuid: String = UUID().uuidString
    let timestamp: Date = Date()
    let title: String
    let description: String
    var user: UserAccount?
    var numberOfComments: Int?
    
    mutating func populate() {
        href = UndeadBreadAPI.shared.baseURL.appendingPathComponent(PostResource.getPostRoute.uri.replacingOccurrences(of: "{id}", with: uuid))
        links = [
            "addComment": UndeadBreadAPI.shared.baseURL.appendingPathComponent(PostResource.commentOnPostRoute.uri.replacingOccurrences(of: "{id}", with: uuid)),
            "getComments": UndeadBreadAPI.shared.baseURL.appendingPathComponent(PostResource.getCommentsRoute.uri.replacingOccurrences(of: "{id}", with: uuid))
        ]
        numberOfComments = Post.commentMap[uuid]?.count ?? 0
    }
}

struct PostCollection: Codable {
    let posts: [Post]
}
