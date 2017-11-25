//
//  GithubAPIService.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import Foundation

class GithubAPIService: NetworkServiceRequestable {
    
    enum Endpoint: URLConvertible {
        
        static private let baseURL = URL(string: "https://api.github.com/")!
        case userRepos(user: String)
        case repo(fullRepoName: String)
        case issues(fullReponame: String)
        case pullRequests(fullReponame: String)
        
        func asURL() throws -> URL {
            switch self {
            case .userRepos(let userName):
                return URL(string: "users/\(userName)/repos", relativeTo: Endpoint.baseURL)!
            case .repo(let fullRepoName):
                return URL(string: "repos/\(fullRepoName)", relativeTo: Endpoint.baseURL)!
            case .issues(let fullRepoName):
                return URL(string: "repos/\(fullRepoName)/issues", relativeTo: Endpoint.baseURL)!
            case .pullRequests(let fullRepoName):
                return URL(string: "repos/\(fullRepoName)/pulls", relativeTo: Endpoint.baseURL)!
            }
        }
    }
}
