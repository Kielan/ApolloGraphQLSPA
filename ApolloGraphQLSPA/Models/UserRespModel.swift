//
//  UserModel.swift
//  ApolloGraphQLSPA
//
//  Created by Kielan Lemons on 6/6/18.
//  Copyright © 2018 Kielan Lemons. All rights reserved.
//

import Foundation

struct UserRespModel: Decodable {
    let username: String
    let email: String
}
