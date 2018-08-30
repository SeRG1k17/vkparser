//
//  User.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/18/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name

struct User {

    let id: Int
    let firstName: String
    let lastName: String
    let photo: String

    var fullName: String {
        return firstName + " " + lastName
    }
}

extension User: Decodable {

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName
        case photo100
    }

    init(from decoder: Decoder) throws {

        let userContainer = try decoder.container(keyedBy: CodingKeys.self)

        id = try userContainer.decode(Int.self, forKey: .id)
        firstName = try userContainer.decode(String.self, forKey: .firstName)
        lastName = try userContainer.decode(String.self, forKey: .lastName)
        photo = try userContainer.decode(String.self, forKey: .photo100)
    }
}
