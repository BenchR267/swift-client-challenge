//
//  Issue.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import Foundation

typealias Issues = [Issue]
struct Issue: Codable {
    let title: String
    let state: State
    let comments: Int
    let created: Date
    let updated: Date?
    
    enum State: String, Codable {
        case open
        case closed
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case state
        case comments
        case created = "created_at"
        case updated = "updated_at"
    }
}
