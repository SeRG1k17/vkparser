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
    @objc dynamic var title: String = ""
    @objc dynamic var added: Date = Date()
    
    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension WallItem: IdentifiableType {
    
    var identity: Int {
        return isInvalidated ? 0 : uid
    }
}
