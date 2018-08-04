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
    
    @objc dynamic var uid: Int = 0
    @objc dynamic var userId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var added: Date = Date()
    
    override class func primaryKey() -> String? {
        return "uid"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        
        guard let rhs = object as? WallItem else { return false }
        
        return userId == rhs.userId && title == rhs.title
    }
}

extension WallItem: IdentifiableType {
    
    var identity: Int {
        return isInvalidated ? 0 : uid
    }
}
