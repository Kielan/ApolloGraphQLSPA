//
//  DemoAuth.swift
//  ApolloGraphQLSPA
//
//  Created by Kielan Lemons on 6/4/18.
//  Copyright © 2018 Kielan Lemons. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void)
        -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}


struct AuthService {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func login(requestModel: FetchAuthLocalStrategyModel, networkRequest: NetworkRequest) {
        guard let url = ProcessInfo.processInfo.environment["API_URL"] + "/auth"
        //is there a better way to do this? let me know.
        let dataTask = session.dataTask(with: url) { data, response, error in
            let courses = try JSONDecoder().decode([UserRespModel].self, from: data)
            networkRequest.start(dataTask)
            
        }
        
    }
}
