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
    
    let searchSubject = Variable<String>("")
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
        
        let searchObservable = searchSubject.asObservable()
            .do(onNext: { value in
                self.state.value = value.isEmpty ? .empty : .loading
            })
            //.filter { !$0.isEmpty }
            .share()
            
            
        let storeObs = searchObservable
            //.delay(1.0, scheduler: MainScheduler.instance)
            .flatMap { value in
                self.storeService.wallItems(for: value).map { $0.toArray() }
            }
            .map { items in
                ("Store", items)
        }
        
        let externalObs = searchObservable
            .delay(2.0, scheduler: MainScheduler.instance)
            .flatMapLatest { value in
                self.vkApiService.wallItems(for: value)
            }
            .flatMap { items in
                self.storeService.save(items: items, for: self.searchSubject.value)
            }
            .flatMapLatest { _ in
                self.storeService.wallItems(for: self.searchSubject.value)
                    .map { $0.toArray() }
            }
            .map { ("Network + Store", $0) }
        //
        //            externalObs
        //            .subscribe(onNext: { arrayOfObservables in
        //                print("saved")
        //            })
        //        .disposed(by: disposeBag)
        
        Observable.merge(storeObs, externalObs)
            //storeObs
            //externalObs
            .distinctUntilChanged({ old, new -> Bool in
                old.1 == new.1
            })
            .subscribe(onNext: { tuple in
                
                print("Update dataSource by \(tuple.0)")
                let sections = [WallSection(model: "Wall", items: tuple.1)]
                
                self.state.value = .loaded(sections)
            })
            .disposed(by: disposeBag)
    }
    
//    private func onChanged(_ userId: String) {
//
//        state.value = .loading
//
//        let qw = storeService.wallItems(for: userId)
//            .delay(3.0, scheduler: MainScheduler.instance)
//            .map { results in
//                return [WallSection(model: "Wall", items: results.toArray())]
//            }
//            .flatMapLatest { sections in
//                //MERGE HERE
//                return vkApiService.wallItems(for: userId)
//            }
//            .subscribe(onNext: { sections in
//                self.state.value = .loaded(sections)
//            })
//            .disposed(by: disposeBag)
//    }
}
