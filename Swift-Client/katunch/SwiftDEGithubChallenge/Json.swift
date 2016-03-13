//
//  Json.swift
//  SwiftDEGithubChallenge
//
//  Created by Silas Knobel on 09/03/16.
//  Copyright © 2016 Katun. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]
typealias JSONCollection = [JSON]

protocol JsonDecodable {
    init?(json: JSON)
}

protocol JsonCollectionDecodable {}

extension JsonCollectionDecodable where Self: JsonDecodable {
    static func collection(json: JSONCollection) -> [Self] {
        var data: [Self] = []
        
        for part in json {
            if let d = Self(json: part) {
                data.append(d)
            }
        }
        
        return data
    }
}

infix operator <~~ { associativity left precedence 150 }

func <~~ <T>(key: String, json: JSON) -> T {
    return json[key] as! T
}

infix operator <?~~ { associativity left precedence 150 }

func <?~~ <T>(key: String, json: JSON) -> T? {
    return json[key] as? T
}


protocol JsonEncodable {
    func jsonEncoded() -> JSON
}
