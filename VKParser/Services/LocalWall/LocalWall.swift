//
//  LocalWall.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift
import NSObject_Rx

class LocalWall: NSObject, LocalWallService {
    
    private let client: RealmClient
    
    init(client: RealmClient) {
        
        self.client = client
        super.init()
    }
    
    func wallItems(for userId: Int) -> Observable<[WallItem]> {
        
        return client.fetch { _, results in
            
            return results
                .filter("\(WallItem.searchKey) == \(userId)")
                .sorted(byKeyPath: "\(WallItem.sortingKey)", ascending: false)
        }
    }
    
    @discardableResult func create(items: [WallItem]) -> Observable<[WallItem]> {
        
        return client.updateMany(models: items, merge: { realm, old, new in
            
            old.text = new.text
            return old
//            
//            if let old = old {
//                old.text = new.text
//                return old
//                
//            } else {
//                new.incrementId(in: realm)
//                return new
//            }
        })
    }
    
    @discardableResult func save(wallItem: WallItem) -> Observable<WallItem> {
        return client.update(model: wallItem)
    }
    
    @discardableResult func delete(wallItem: WallItem) -> Observable<Void> {
        return client.delete(model: wallItem)
    }
}
