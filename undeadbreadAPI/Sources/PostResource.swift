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
    static let getPostRoute = Route(method: .get, uri: "/post/{id}", handler: getPostHandler)
    static let getPostsRoute = Route(method: .get, uri: "/posts", handler: getPostsHandler)
    static let commentOnPostRoute = Route(method: .put, uri: "/post/{id}/comment", handler: commentOnPostHandler)
    static let getCommentsRoute = Route(method: .get, uri: "/post/{id}/comments", handler: getCommentsHandler)

    
    class func createPostHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        guard let bytes = request.postBodyBytes else {
            response.completed(status: .badRequest)
            return
        }
        let body = Data(bytes: bytes)
        guard var post = try? JSONDecoder().decode(Post.self, from: body) else {
            response.completed(status: .badRequest)
            return
        }
        let user = UserAccount.authenticate(with: request)!
        post.user = user
        Post.posts[post.uuid] = post
        post.populate()
        try? response.appendBody(encodable: post)
        response.completed(status: .created)
    }
    
    class func getPostHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        response.setHeader(.cacheControl, value: "max-age=10")
        
        guard let id = request.urlVariables["id"]?.string else {
            response.completed(status: .badRequest)
            return
        }
        
        var post = Post.posts[id]
        post?.populate()
        try? response.appendBody(encodable: post)
        response.completed(status: .ok)
    }
    
    class func getPostsHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        response.setHeader(.cacheControl, value: "max-age=10")
        
        var posts = Post.posts.values.array
        for index in posts.indices {
            posts[index].populate()
        }
        let serializablePosts = PostCollection(posts: posts)
        try? response.appendBody(encodable: serializablePosts)
        response.completed(status: .ok)
    }
    
    class func commentOnPostHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        response.setHeader(.cacheControl, value: "max-age=10")
        guard let id = request.urlVariables["id"]?.string else {
            response.completed(status: .badRequest)
            return
        }
        guard let bytes = request.postBodyBytes else {
            response.completed(status: .badRequest)
            return
        }
        let body = Data(bytes: bytes)
        guard var comment = try? JSONDecoder().decode(Comment.self, from: body) else {
            response.completed(status: .badRequest)
            return
        }
        comment.user = UserAccount.authenticate(with: request)
        comment.postId = id
        Post.commentMap[id, default: []].append(comment)
        
        response.completed(status: .created)
    }
    
    class func getCommentsHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        response.setHeader(.cacheControl, value: "max-age=10")
        guard let id = request.urlVariables["id"]?.string else {
            response.completed(status: .badRequest)
            return
        }
        
        let comments = Post.commentMap[id] ?? []
        let serializableComments = CommentCollection(comments: comments)
        try? response.appendBody(encodable: serializableComments)
        response.completed(status: .ok)
    }
    

}

extension PostResource: Resource {
    class var routes: [Route] {
        return rootRoutes+[getPostRoute, commentOnPostRoute, getCommentsRoute]
    }
    
    class var rootRoutes: [Route] {
        return [createPostRoute, getPostsRoute]
    }
}
