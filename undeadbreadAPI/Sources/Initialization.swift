//
//  Initialization.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/11/17.
//

import Foundation

struct Initialization: Entity {
    let href: URL = UndeadBreadAPI.shared.baseURL
    let links: [String : URL] = {
       return [
            "register" : AuthenticationResource.registerRoute.absoluteURLString.urlValue!,
            "login" : AuthenticationResource.loginRoute.absoluteURLString.urlValue!,
            "token" : AuthenticationResource.tokenRoute.absoluteURLString.urlValue!,
            "createPost" : PostResource.createPostRoute.absoluteURLString.urlValue!,
            "posts" : PostResource.getPostsRoute.absoluteURLString.urlValue!
        ]
    }()
}
