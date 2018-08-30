//
//  NetworkWallService.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift

protocol NetworkWallService {

    func wallItems(for userId: String) -> Observable<[WallItem]>
    func delete(item: WallItem) -> Observable<Void>
    func edit(item: WallItem, text: String) -> Observable<Void>
}
