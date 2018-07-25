//
//  ParserViewModel.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action

typealias WallSection = AnimatableSectionModel<String, WallItem>

struct ParserViewModel {
    
    private let sceneCoordinator: SceneCoordinatorType
    private let vkApiService: VKApiService
    private let storeService: StoreService
    
    //var searchText = Variable<String>("")
    
    init(coordinator: SceneCoordinatorType, vkApiService: VKApiService, storeService: StoreService) {
        
        self.sceneCoordinator = coordinator
        self.vkApiService = vkApiService
        self.storeService = storeService
        
//        searchText.asObservable()
//            .subscribe(onNext: { value in
//                self.onChanged(value)
//            })
    }
    
    var sectionedItems: Observable<[WallSection]> {
        return storeService.wallItems
            .map { results in
                return [WallSection(model: "Wall", items: results.toArray())]
        }
    }
    
    lazy var deleteAction: Action<WallItem, Void> = { (service: StoreService) in
        return Action { item in
            return service.delete(wallItem: item)
        }
    }(self.storeService)
    
//    lazy var editAction: Action<String, Void> = { this in
//        return Action { task in
//
//            return this.vkApiService.getWallItems()
//        }
//    }(self)
    
    func onChanged(_ userId: String) {
        
        vkApiService.wallItems(for: userId)
    }
}
