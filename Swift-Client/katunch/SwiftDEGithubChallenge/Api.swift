//
//  Api.swift
//  SwiftDEGithubChallenge
//
//  Created by Silas Knobel on 09/03/16.
//  Copyright © 2016 Katun. All rights reserved.
//

import Foundation

class Api {
    
    //MARK: Singleton
    static let sharedInstance = Api()
    
    
    //MARK: Properties
    var username: String = "katunch"
    
    //MARK: Github API Calls
    func repositoryList(completion: ((repos: [GithubRepo], error: ErrorType? ) -> Void)) {
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = NSURL(string: "https://api.github.com/users/\(username)/repos") else { return }
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                debugPrint("URL Session Task Succeeded: HTTP \(statusCode)")
                if statusCode != 200 {
                    Utils.dispatchOnMainQueue({ () -> Void in
                        completion(repos: [], error: ApiError.NotFound)
                    })
                    return
                }
                guard let d = data else {
                    Utils.dispatchOnMainQueue({ () -> Void in
                        completion(repos: [], error: ApiError.NotFound)
                    })
                    return
                }
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions(rawValue: 0))
                    let repos = GithubRepo.collection(json as! JSONCollection)
                    Utils.dispatchOnMainQueue({ () -> Void in
                        completion(repos: repos, error: nil)
                    })
                } catch let e {
                    debugPrint(e)
                    Utils.dispatchOnMainQueue({ () -> Void in
                        completion(repos: [], error: e)
                    })
                }
            }
            else {
                debugPrint("URL Session Task Failed: %@", error!.localizedDescription)
                Utils.dispatchOnMainQueue({ () -> Void in
                    completion(repos: [], error: error)
                })
            }
        })
        task.resume()

    }
}

enum ApiError: ErrorType {
    case NotFound
}