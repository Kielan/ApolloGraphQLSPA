//
//  NetworkRequest.swift
//  ApolloGraphQLSPA
//
//  Created by Kielan Lemons on 6/5/18.
//  Copyright © 2018 Kielan Lemons. All rights reserved.
//
//streamable api extension for network requests kinda like apollo or node...
import Foundation

protocol URLSessionTaskProtocol: class {
    func resume()
    func cancel()
}

extension URLSessionTask: URLSessionTaskProtocol {}

class NetworkRequest {
    private(set) var currentTask: URLSessionTaskProtocol?
    
    func start(_ task: URLSessionTaskProtocol) {
        precondition(currentTask == nil)
        currentTask = task
        task.resume()
    }
    
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}

