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
    
    var searchSubject: PublishSubject<String> { get }
    var loadedWallItems: PublishSubject<[WallItem]> { get }

    func delete(item: WallItem, closure: ((WallItem) -> Void)?)
}
