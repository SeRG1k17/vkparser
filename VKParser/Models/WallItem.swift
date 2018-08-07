//
//  WallItem.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class WallItem: Object {
    
    //@objc dynamic var uid: Int = 0
    
    @objc dynamic var id: Int = 0
    @objc dynamic var fromId: String = ""
    @objc dynamic var ownerId: String = ""
    
    @objc dynamic var date: Date = Date()
    @objc dynamic var text: String = ""
    
    @objc dynamic var likesCount: Int = 0
    @objc dynamic var viewsCount: Int = 0
    @objc dynamic var repostsCount: Int = 0
    @objc dynamic var commentsCount: Int = 0
    
    
    class var searchKey: String {
        return #keyPath(ownerId)
    }
    
    private class var key: String {
        return #keyPath(id)
    }
    
    override class func primaryKey() -> String? {
        return key
    }
    
    static func lastId(in realm: Realm) -> Int {
        return realm.objects(WallItem.self).max(ofProperty: WallItem.key) ?? 0
    }
    
    func incrementId(in realm: Realm) {
        id = WallItem.lastId(in: realm) + 1
    }
    
//    override func isEqual(_ object: Any?) -> Bool {
//
//        guard let rhs = object as? WallItem else { return false }
//
//        return userId == rhs.userId && title == rhs.title
//    }
}

extension WallItem: IdentifiableType {
    
    var identity: Int {
        return isInvalidated ? 0 : id
    }
}
