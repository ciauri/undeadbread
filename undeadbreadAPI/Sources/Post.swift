//
//  Post.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 11/15/17.
//

import Foundation

struct Post: Codable {
    static var posts: [String:Post] = [:]
    
    
    let uuid: String = UUID().uuidString
    let title: String
    let description: String
}
