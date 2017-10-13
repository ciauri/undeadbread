//
//  Tool.swift
//  undeadbread
//
//  Created by stephenciauri on 8/13/17.
//  Copyright © 2017 Stephen Ciauri. All rights reserved.
//

import Foundation

struct Tool {
    var name: String 
}

extension Tool: CustomStringConvertible {
    var description: String {
        return name
    }
}
