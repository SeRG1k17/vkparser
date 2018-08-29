//
//  LocalWallService.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift

protocol LocalWallService {
    
    @discardableResult func create(items: [WallItem]) -> Observable<[WallItem]>
    @discardableResult func delete(wallItem: WallItem) -> Observable<Void>
    @discardableResult func delete(wallItems: [WallItem]) -> Observable<Void>
    @discardableResult func update(wallItem: WallItem, text: String) -> Observable<WallItem>
    func wallItems(for userId: Int) -> Observable<[WallItem]>
}
