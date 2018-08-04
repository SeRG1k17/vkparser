//
//  StoreService.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol StoreService {
    
    var wallItems: Observable<Results<WallItem>> { get }
    
    @discardableResult func save(wallItem: WallItem) -> Observable<WallItem>
    func save(items: [WallItem], for userId: String) -> Observable<[WallItem]>
    //func save(items: [WallItem], for userId: String) -> Observable<[Observable<WallItem>]>
    @discardableResult func delete(wallItem: WallItem) -> Observable<Void>
    
    func wallItems(for userId: String) -> Observable<Results<WallItem>>
}
