//
//  GithubRepo.swift
//  SwiftDEGithubChallenge
//
//  Created by Silas Knobel on 09/03/16.
//  Copyright © 2016 Katun. All rights reserved.
//

import Foundation

struct GithubRepo: JsonDecodable, JsonCollectionDecodable {
    var name: String
    var description: String?
    var url: NSURL
    
    init?(json: JSON) {
        name = "name" <~~ json
        url = NSURL(string: "html_url" <~~ json)!
        description = "description" <?~~ json
    }
}
