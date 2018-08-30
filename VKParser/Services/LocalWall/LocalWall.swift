//
//  LocalWall.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift

class LocalWall: LocalWallService {

    private let client: RealmClient
    private let disposeBag = DisposeBag()

    init(client: RealmClient) {

        self.client = client
    }

    func wallItems(for userId: Int) -> Observable<[WallItem]> {

        return client.fetch { _, results in

            return results
                .filter("\(WallItem.searchKey) == \(userId)")
                .sorted(byKeyPath: "\(WallItem.sortingKey)", ascending: false)
        }
    }

    @discardableResult func create(items: [WallItem]) -> Observable<[WallItem]> {

        return self.client.updateMany(models: items) { _, old, new in
            old.text = new.text
            return old
        }
    }

    @discardableResult func save(wallItem: WallItem) -> Observable<WallItem> {
        return client.update(model: wallItem)
    }

    @discardableResult func delete(wallItem: WallItem) -> Observable<Void> {
        return client.delete(model: wallItem)
    }

    @discardableResult func delete(wallItems: [WallItem]) -> Observable<Void> {
        return client.delete(models: wallItems)
    }

    @discardableResult func update(wallItem: WallItem, text: String) -> Observable<WallItem> {
        return client.update(model: wallItem) { _, model in
            model.text = text
        }
    }
}
