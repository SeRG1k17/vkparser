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
        
        return Observable
            .create({ observer in
            
            if userId == "1" {
                let item = WallItem()
                item.userId = "1"
                item.title = "Title from external post"
                
                let item1 = WallItem()
                item1.userId = "1"
                item1.title = "Test title 1"
                
                let item2 = WallItem()
                item2.userId = "1"
                item2.title = "DFGDFgdf DG dfg dfg"
                
                let item3 = WallItem()
                item3.userId = "1"
                item3.title = "dfgdffg g"
                
                observer.onNext([item, item1, item2, item3])
            } else {
                observer.onNext([])
            }
            return Disposables.create()
        })
        .delay(1.0, scheduler: MainScheduler.instance)
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
