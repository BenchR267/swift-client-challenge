//
//  NetworkServiceRequestable.swift
//  Architekturen
//
//  Created by Marius Landwehr on 25.11.17.
//  Copyright © 2017 swiftde. All rights reserved.
//

import Foundation

protocol NetworkServiceRequestable {
    @discardableResult
    func response(urlConvertible: URLConvertible, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension NetworkServiceRequestable {
    
    @discardableResult
    func response(urlConvertible: URLConvertible, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: try! urlConvertible.asURL()) { (data, response, error) in
            if let error = error {
                completion(nil, response, error)
            }
            guard let data = data else {
                assertionFailure("We got no data… this is bad")
                return
            }
            completion(data, response, error)
        }
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    func responseDecodable<T: Decodable>(urlConvertible: URLConvertible, completion: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        return response(urlConvertible: urlConvertible, completion: { (data, response, error) in
            
            DispatchQueue.global(qos: .background).async {
                
                let dispatchCompletion: (T?, URLResponse?, Error?) -> () = { codable, response, error in
                    DispatchQueue.main.async {
                        completion(codable, response, error)
                    }
                }
                
                guard let data = data else {
                    assertionFailure("We got no data… this is bad")
                    completion(nil, response, nil)
                    return
                }
            
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    let codable = try jsonDecoder.decode(T.self, from: data)
                    dispatchCompletion(codable, response, nil)
                } catch {
                    dispatchCompletion(nil, response, error)
                }
            }
        })
    }
}
