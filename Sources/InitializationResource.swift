//
//  InitializationResource.swift
//  undeadbreadAPI
//
//  Created by stephenciauri on 10/11/17.
//

import Foundation
import PerfectHTTP
import PerfectLib

class InitializationResource {
    static let initRoute = Route(method: .get, uri: "/", handler: initHandler)
    
    class func initHandler(request: HTTPRequest, response: HTTPResponse) {
        response.setHeader(.contentType, value: "application/json")
        do {
            try response.appendBody(encodable: Initialization())
        } catch {
            NSLog("Failed to serialize init")
            response.completed(status: .internalServerError)
            return
        }
        
        response.completed(status: .ok)
    }
}

extension InitializationResource: Resource {
    class var routes: [Route] {
        return [initRoute]
    }
    
    class var rootRoutes: [Route] {
        return routes
    }
}
