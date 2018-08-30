//
//  StoreService.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift

protocol LocalWallItemsService {

    //@discardableResult func save(wallItem: WallItem) -> Observable<WallItem>
    @discardableResult func create(items: [WallItem]) -> Observable<[WallItem]>
    @discardableResult func delete(wallItem: WallItem) -> Observable<Void>

    func wallItems(for userId: Int) -> Observable<[WallItem]>
}
