//
//  PostResource.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 11/15/17.
//

import Foundation

import Foundation
import PerfectHTTP
import PerfectLib

class PostResource {
    static let createPostRoute = Route(method: .put, uri: "/post", handler: createPostHandler)
    
    class func createPostHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        guard let bytes = request.postBodyBytes else {
            response.completed(status: .badRequest)
            return
        }
        let body = Data(bytes: bytes)
        guard let post = try? JSONDecoder().decode(Post.self, from: body) else {
            response.completed(status: .badRequest)
            return
        }
        Post.posts[post.uuid] = post
        try? response.appendBody(encodable: post)
        response.completed(status: .created)
    }
}

extension PostResource: Resource {
    class var routes: [Route] {
        return [createPostRoute]
    }
    
    class var rootRoutes: [Route] {
        return routes
    }
}
