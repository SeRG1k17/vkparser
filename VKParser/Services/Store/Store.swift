//
//  Store.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import RealmSwift

struct Store: StoreService {
    
    var wallItems: Observable<Results<WallItem>> {
        
        let result = withRealm(#function) { realm -> Observable<Results<WallItem>> in
            let items = realm.objects(WallItem.self)
            return Observable.collection(from: items)
        }
        
        return result ?? .empty()
    }
    
    init() {
        // create a few default tasks
        do {
            let realm = try Realm()
            if realm.objects(WallItem.self).isEmpty {
                self.testItems.forEach {
                    self.save(wallItem: $0)
                }
            }
        } catch _ {
        }
    }
    
    func save(wallItems: [WallItem]) -> [Observable<WallItem>] {
        return wallItems.map { self.save(wallItem: $0) }
    }
    
    @discardableResult func save(wallItem: WallItem) -> Observable<WallItem> {
        
        let result = withRealm(#function) { realm -> Observable<WallItem> in
            
            try realm.write {
                wallItem.uid = (realm.objects(WallItem.self).max(ofProperty: "uid") ?? 0) + 1
                realm.add(wallItem)
            }
            return .just(wallItem)
        }
        
        return result ?? .error(StoreServiceError.save(wallItem))
    }
    
    @discardableResult func delete(wallItem: WallItem) -> Observable<Void> {
        
        let result = withRealm(#function) { realm -> Observable<Void> in
            
            try realm.write {
                realm.delete(wallItem)
            }
            return .empty()
        }
        
        return result ?? .error(StoreServiceError.delete(wallItem))
    }
    
    private func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    private var testItems: [WallItem] {
        return ["Chapter 5: Filtering operators",
                "Chapter 4: Observables and Subjects in practice",
                "Chapter 3: Subjects",
                "Chapter 2: Observables",
                "Chapter 1: Hello, RxSwift"].map {
                    let item = WallItem()
                    item.title = $0
                    return item
        }
    }
}
