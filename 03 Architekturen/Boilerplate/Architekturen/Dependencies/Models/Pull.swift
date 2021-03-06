//
//  Pull.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import Foundation

typealias Pulls = [Pull]
struct Pull: Decodable {
    let title: String
    let state: State
    let created: Date
    let updated: Date?
    
    enum State: String, Codable {
        case open
        case closed
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case state
        case created = "created_at"
        case updated = "updated_at"
    }
}
