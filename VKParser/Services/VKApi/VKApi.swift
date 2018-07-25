//
//  VKApi.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
//import VKSdkFramework
import SwiftyVK
import RxSwift

struct VKApi: VKApiService {
    
    func wallItems(for userId: String) -> Observable<[WallItem]> {
        
        return Observable.create({ observer -> Disposable in
            
            let item = WallItem()
            item.userId = userId
            item.title = "Test title"
            
            observer.onNext([item])
            return Disposables.create()
        })
    }
    
    var vkApiDelegate: SwiftyVKDelegate
    
    init(vkApiDelegate: SwiftyVKDelegate) {
        
        self.vkApiDelegate = vkApiDelegate
        
        VK.API.Users.get([.userId: "1",
                          .wallpost: "50"])
        .onSuccess { data in
                print(data)
        }
        .onError { error in
                print(error)
        }
        .send()
    }
}
