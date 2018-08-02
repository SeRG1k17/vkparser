//
//  Wall.swift
//  VKParser
//
//  Created by Sergey on 7/19/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift

class Wall: WallService {
    
    var store: StoreService
    var vkApi: VKApiService
    
    init(store: StoreService, vkApi: VKApiService) {
        
        self.store = store
        self.vkApi = vkApi
    }
    
    func wallItems(for userId: String) -> Observable<[WallItem]> {
        
        //store.get
        return Observable.create({ observer -> Disposable in
            observer.onNext([])
            return Disposables.create()
        })
    }
}
