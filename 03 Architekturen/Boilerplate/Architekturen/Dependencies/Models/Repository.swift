//
//  Repo.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import Foundation

typealias Repositories = [Repository]
struct Repository: Codable {
    let name: String
    let fullName: String
    let description: String?
    let stars: Int
    let watchers: Int?
    let forks: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case description
        case stars = "stargazers_count"
        case watchers = "subscribers_count"
        case forks
    }
}
