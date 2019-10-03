//
//  APIClient.swift
//  StackOverFlowTest
//
//  Created by Arbi Derhartunian on 9/28/19.
//  Copyright © 2019 com.green. All rights reserved.
//

import Foundation
import UIKit

// MARK: - NetworkError

/// _NetworkError_ is an enumeration that specifies network errors
///
/// - generic:    Generic error
/// - invalidURL: Invalid URL error
enum NetworkError: Error {
    case generic
    case invalidURL
}

// MARK: - NetworkClientProtocol

/// _NetworkClientProtocol_ is a protocol specifies send network requests behaviour
protocol APIClientProtocol {
    func get(url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}

// MARK: - NetworkClient

/// _NetworkClient_ is a class responsible for network requests
class APIClient: APIClientProtocol {
  
    public static let BaseUrl = "https://api.stackexchange.com/2.2"
    
    let session: URLSession!
    
    // MARK: - Initialisers
    /// Initializes an instance of _APIClient_
    ///
    /// - returns: The instance of _APIClient_
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        configuration.timeoutIntervalForRequest = 5.0
        session = URLSession(configuration: configuration)
    }
    
    // MARK: - Send requests
    
    /// Sends a URL request
    ///
    /// - parameter request:    The URL request
    /// - parameter completion: The completion block
    
    func get(url: URL?, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = url else {
            completion(nil, nil, NetworkError.invalidURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "get"
        DispatchQueue.global().async {
            self.session.dataTask(with: url) { data, response, error in
                guard let response = response as? HTTPURLResponse else {
                    completion(nil,nil,NetworkError.generic)
                    return
                }
                DispatchQueue.main.async {
                    if(response.statusCode >= 200){
                        completion(data, response, error)
                    }else{
                        completion(data,response,NetworkError.generic)
                    }
                }
            }.resume()
        }
    }
}
