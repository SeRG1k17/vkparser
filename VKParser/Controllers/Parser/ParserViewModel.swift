//
//  ParserViewModel.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxDataSources

typealias WallSection = AnimatableSectionModel<String, WallItem>

struct ParserViewModel {
    
    private let sceneCoordinator: SceneCoordinatorType
    private let serviceLocator: ServiceLocator
    
    var tableManager: ParserTableManager?
    
    let searchVariable = Variable<String>("")
    let state = Variable<State>(.empty)
    
    private let disposeBag = DisposeBag()
    
    
    init(coordinator: SceneCoordinatorType, serviceLocator: ServiceLocator) {
        
        self.sceneCoordinator = coordinator
        self.serviceLocator = serviceLocator

        setUpObservables()
    }

    lazy var deleteAction: Action<WallItem, Void> = { (service: ServiceLocator) in
        return Action { item in
            return service.localWall.delete(wallItem: item)
        }
    }(self.serviceLocator)
    
    var sectionedItems: Observable<[WallSection]> {
        return self.serviceLocator.localWall.wallItems(for: 1).map { items in
            return [WallSection(model: "Wall", items: items)]
        }
    }
    
    func delete(item: WallItem) {
        
        self.serviceLocator.localWall.delete(wallItem: item)
//
//        serviceLocator.networkWall.delete(item: item) { deletedItem in
//            self.serviceLocator.localWall.delete(wallItem: deletedItem)
//        }
    }
    
    private func setUpObservables() {
        
        let searchObservable = searchVariable.asObservable()
            .do(onNext: { value in
                self.state.value = value.isEmpty ? .empty : .loading
            })
            .share()
        
        searchObservable
            .filter { !$0.isEmpty }
            .bind(to: serviceLocator.networkWall.searchSubject)
            .disposed(by: disposeBag)
        
        serviceLocator.networkWall.loadedWallItems
            .subscribe(onNext: { items in
                self.serviceLocator.localWall.create(items: items)
            })
            .disposed(by: disposeBag)
        
        
        searchObservable
            .map { Int($0) ?? 0 }
            .map { self.serviceLocator.localWall.wallItems(for: $0)
                .map { [WallSection(model: "Wall", items: $0)] }
            }
            .map { State.loaded($0) }
            .bind(to: state)
            .disposed(by: disposeBag)
        
//        return self.serviceLocator.localWall.wallItems(for: 1).map { items in
//            return [WallSection(model: "Wall", items: items)]
//            }
//            .flatMapLatest { value in
//                self.serviceLocator.localWall.wallItems(for: value)
//            }
//            .map { items
//            }
//            .subscribe(onNext: { items in
//                
//                let sections = [WallSection(model: "Wall", items: items)]
//                self.state.value = .loaded(sections)
//            })
//            .disposed(by: disposeBag)
    }
}

extension ParserViewModel {
    
    enum State {
        case empty
        case loading
        case error
        //case loaded
        case loaded(Observable<[WallSection]>)
        
        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
}
