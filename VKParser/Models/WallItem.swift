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
    
    @objc dynamic var keyId: Int = 0
    
    @objc dynamic var id: Int = 0
    @objc dynamic var fromId: Int = 0
    @objc dynamic var ownerId: Int = 0
    
    @objc dynamic var authorName: String = ""
    @objc dynamic var authorPhoto: String = ""
    
    @objc dynamic var date: Date = Date()
    @objc dynamic var text: String = ""
    
    @objc dynamic var likesCount: Int = 0
    var viewsCount = RealmOptional<Int>(0)
    @objc dynamic var repostsCount: Int = 0
    @objc dynamic var commentsCount: Int = 0
    @objc dynamic var canDelete: Bool = false
    @objc dynamic var canEdit: Bool = false
    
    class var searchKey: String {
        return #keyPath(ownerId)
    }
    
    class var sortingKey: String {
        return #keyPath(date)
    }
    
    private class var key: String {
        return #keyPath(keyId)
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
    
    override func isEqual(_ object: Any?) -> Bool {

        guard let rhs = object as? WallItem else { return false }

        return fromId == rhs.fromId &&
            ownerId == rhs.ownerId &&
            text == rhs.text &&
            date == rhs.date &&
            authorName == rhs.authorName &&
            authorPhoto == rhs.authorPhoto &&
            likesCount == rhs.likesCount &&
            repostsCount == rhs.repostsCount &&
            commentsCount == rhs.commentsCount &&
            viewsCount.value == rhs.viewsCount.value &&
            canDelete == rhs.canDelete &&
            canEdit == rhs.canEdit
    }
}

extension WallItem: Comparable {
    
    static func < (lhs: WallItem, rhs: WallItem) -> Bool {
        return lhs.date < rhs.date
    }
}

extension WallItem: IdentifiableType {
    
    var identity: Int {
        return isInvalidated ? 0 : keyId
    }
}
