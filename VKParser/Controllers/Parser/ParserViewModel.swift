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

enum State {
    case empty
    case loading
    case error
    //case loaded
    case loaded([WallSection])
    
    var isLoading: Bool {
        switch self {
        case .loading: return true
        default: return false
        }
    }
}

struct ParserViewModel {
    
    private let sceneCoordinator: SceneCoordinatorType
    private let vkApiService: VKApiService
    private let storeService: StoreService
    
    let searchSubject = PublishSubject<String>()
    let state = Variable<State>(.empty)
    
    private let disposeBag = DisposeBag()
    
    
    init(coordinator: SceneCoordinatorType, vkApiService: VKApiService, storeService: StoreService) {
        
        self.sceneCoordinator = coordinator
        self.vkApiService = vkApiService
        self.storeService = storeService

        setUpObservables()
    }

    lazy var deleteAction: Action<WallItem, Void> = { (service: StoreService) in
        return Action { item in
            return service.delete(wallItem: item)
        }
    }(self.storeService)
    
    private func setUpObservables() {
        
        searchSubject
            .subscribe(onNext: { value in

                if value.isEmpty {
                    self.state.value = .empty
                } else {
                    self.onChanged(value)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func onChanged(_ userId: String) {
        
        state.value = .loading
        
        storeService.wallItems(for: userId)
            .delay(3.0, scheduler: MainScheduler.instance)
            .map { results in
                return [WallSection(model: "Wall", items: results.toArray())]
            }
            .subscribe(onNext: { sections in
                self.state.value = .loaded(sections)
            })
            .disposed(by: disposeBag)
    }
}
