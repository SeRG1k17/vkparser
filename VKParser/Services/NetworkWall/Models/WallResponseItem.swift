//
//  WallResponseItem.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/18/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation

struct WallResponseItem: Decodable {
    
    var wallItems: [WallItem]
    
    enum RootCodingKeys: CodingKey {
        case items, profiles, groups
        
        enum ItemCodingKeys: CodingKey {
            case id, fromId, ownerId, date, postType, text, postSource, comments, likes, reposts, views
            
            enum CountCodingKeys: CodingKey {
                case count
            }
        }
        
//        enum ProfileCodingKeys: CodingKey {
//            case id, firstName, lastName, photo50, photo100, online
//        }
    }
    
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
}
