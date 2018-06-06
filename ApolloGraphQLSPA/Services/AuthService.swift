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
    private let authParametersGenerator: () -> String
    
    init(session: URLSessionProtocol, authParametersGenerator: @escaping () -> String) {
        self.session = session
        self.authParametersGenerator = authParametersGenerator
    }
    
    func login(requestModel: FetchAuthLocalStrategyModel, networkRequest: NetworkRequest) {
        guard let url = makeURL(requestModel: requestModel) else {
            return
        }
        //is there a better way to do this? let me know.
        let dataTask = session.dataTask(with: url) { data, response, error in
            print("error: \(String(describing: error))")
            print("response: \(String(describing: response))")
            let str = String(data: data ?? Data(), encoding: .utf8)
            print("data: \(String(describing: str))")
        }
        networkRequest.start(dataTask)
    }
    private func makeURL(requestModel: FetchAuthLocalStrategyModel) -> URL? {
        guard let namePrefix = requestModel.namePrefix
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return nil
        }
        return URL(string: ProcessInfo.processInfo.environment["API_URL"] + "/auth")
    }
}
