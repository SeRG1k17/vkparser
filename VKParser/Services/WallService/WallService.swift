//
//  WallService.swift
//  VKParser
//
//  Created by Sergey on 7/19/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift

protocol WallService {
    
    var store: StoreService { get }
    var vkApi: VKApiService { get }
    
    func wallItems(for userId: String) -> Observable<[WallItem]>
}
