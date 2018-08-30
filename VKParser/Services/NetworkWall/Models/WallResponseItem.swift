//
//  WallResponseItem.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/18/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name
struct WallResponseItem: Decodable {

    var wallItems: [WallItem]

    // swiftlint:disable nesting
    enum RootCodingKeys: CodingKey {
        case items, profiles, groups

        enum ItemCodingKeys: CodingKey {
            case id, fromId, ownerId, date, postType, text, postSource
            case comments, likes, reposts, views
            case canDelete, canEdit

            enum CountCodingKeys: CodingKey {
                case count
            }
        }
    }
    // swiftlint:enable nesting

    static let empty = WallResponseItem()

    init() {
        wallItems = []
    }

    init(by data: Data) throws {
        self = try JSONDecoder.vkDecoder.decode(WallResponseItem.self, from: data)
    }

    // swiftlint:disable line_length
    init(from decoder: Decoder) throws {

        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var itemsContainer = try rootContainer.nestedUnkeyedContainer(forKey: .items)

        var items = [WallItem]()
        while !itemsContainer.isAtEnd {

            let itemContainer = try itemsContainer.nestedContainer(keyedBy: RootCodingKeys.ItemCodingKeys.self)

            let item = WallItem()
            item.id = try itemContainer.decode(Int.self, forKey: .id)
            item.fromId = try itemContainer.decode(Int.self, forKey: .fromId)
            item.ownerId = try itemContainer.decode(Int.self, forKey: .ownerId)

            var canDelete = false
            if try itemContainer.decodeIfPresent(Int.self, forKey: .canDelete) != nil {
                canDelete = true
            }
            item.canDelete = canDelete

            var canEdit = false
            if try itemContainer.decodeIfPresent(Int.self, forKey: .canEdit) != nil {
                canEdit = true
            }
            item.canEdit = canEdit

            let dateInterval = try itemContainer.decode(TimeInterval.self, forKey: .date)
            item.date = Date(timeIntervalSince1970: dateInterval)
            item.text = try itemContainer.decode(String.self, forKey: .text)

            item.commentsCount = try itemContainer.nestedContainer(keyedBy: RootCodingKeys.ItemCodingKeys.CountCodingKeys.self, forKey: .comments).decode(Int.self, forKey: .count)

            item.likesCount = try itemContainer.nestedContainer(keyedBy: RootCodingKeys.ItemCodingKeys.CountCodingKeys.self, forKey: .likes).decode(Int.self, forKey: .count)

            item.repostsCount = try itemContainer.nestedContainer(keyedBy: RootCodingKeys.ItemCodingKeys.CountCodingKeys.self, forKey: .reposts).decode(Int.self, forKey: .count)

            item.viewsCount.value = try? itemContainer.nestedContainer(keyedBy: RootCodingKeys.ItemCodingKeys.CountCodingKeys.self, forKey: .views).decode(Int.self, forKey: .count)

            items.append(item)
        }

        let users = try rootContainer.decode([User].self, forKey: .profiles)

        items.forEach { item in
            if let index = users.index(where: { $0.id == item.fromId }) {
                item.authorName = users[index].fullName
                item.authorPhoto = users[index].photo
                item.keyId = item.id.hashValue + users[index].id.hashValue
            }
        }

        self.wallItems = items
    }
    // swiftlint:enable line_length
}
