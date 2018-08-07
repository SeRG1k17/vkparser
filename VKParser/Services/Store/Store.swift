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
    
    func wallItems(for userId: String) -> Observable<Results<WallItem>> {
        
        let result = withRealm(#function) { realm -> Observable<Results<WallItem>> in
            
            let items = realm.objects(WallItem.self).filter("\(WallItem.searchKey) == %@", userId)
            return Observable.collection(from: items)
        }
        return result ?? .empty()
    }
    
//    func save(items: [WallItem], for userId: String) -> Observable<[Observable<WallItem>]> {
//
//        return wallItems(for: userId).map { results in
//            results.toArray()
//            }
//            .map { storedItems in
//                items.filter { !storedItems.contains($0) }
//                    .map { self.save(wallItem: $0) }
//        }
//    }
    
    func save(items: [WallItem], for userId: String) -> Observable<[WallItem]> {

        return wallItems(for: userId).map { results in
            results.toArray()
        }
        .flatMap { storedItems -> Observable<[WallItem]> in

            let newItems = items.filter { !storedItems.contains($0) }

                //.map { self.save(wallItem: $0) }

            let result = self.withRealm(#function) { realm -> Observable<[WallItem]> in

                var index = WallItem.lastId(in: realm) + 1
                newItems.forEach { item in
                    item.id = index
                    index += 1
                }

                try realm.write { realm.add(newItems) }
                return .of(newItems)
            }

            return result ?? .error(StoreServiceError.saveArray(newItems))

            //return newItems
        }
    }
    
    @discardableResult func save(wallItem: WallItem) -> Observable<WallItem> {
        
        let result = withRealm(#function) { realm -> Observable<WallItem> in
            
            try realm.write {
                wallItem.incrementId(in: realm)
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

        let item1 = WallItem()
        item1.text = "Chapter 5: Filtering operators"
        item1.ownerId = "1"

        let item2 = WallItem()
        item2.text = "Chapter 4: Observables and Subjects in practice"
        item2.ownerId = "1"

//        let item3 = WallItem()
//        item3.title = "Chapter 3: Subjects"
//        item3.userId = "1"
//
//        let item4 = WallItem()
//        item4.title = "Chapter 2: Observables"
//        item4.userId = "3"
//
//        let item5 = WallItem()
//        item5.title = "Chapter 1: Hello, RxSwift"
//        item5.userId = "3"

        return [item1, item2/*, item3, item4, item5*/]
    }
}
