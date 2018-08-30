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

    let searchSubject = PublishSubject<String>()
    let state = Variable<State>(.empty)

    private let disposeBag = DisposeBag()

    init(coordinator: SceneCoordinatorType, serviceLocator: ServiceLocator) {

        self.sceneCoordinator = coordinator
        self.serviceLocator = serviceLocator

        registerObservers()
    }

    lazy var deleteAction: Action<WallItem, Void> = { service in
        return Action { item in
            return service.networkWall.delete(item: item)
                .observeOn(MainScheduler.instance)
                .do(onNext: { _ in service.localWall.delete(wallItem: item) })
        }
    }(self.serviceLocator)

    lazy var editAction: Action<WallItem, Void> = { this in
        return Action { item in

            let editViewModel = EditPostViewModel(coordinator: this.sceneCoordinator,
                                                  item: item,
                                                  doneAction: this.onUpdate(item: item))

            return this.sceneCoordinator
                .transition(to: AppScene.editPost(editViewModel), type: .modal)
        }
    }(self)

    private func registerObservers() {

        let searchObservable = searchSubject
            .do(onNext: { self.state.value = $0.isEmpty ? .empty : .loading })
            .share()

        searchObservable
            .filter { !$0.isEmpty }
            .flatMap { value -> Observable<[WallItem]> in
                print(value)
                return self.serviceLocator.networkWall.wallItems(for: value)
            }
        .subscribe(onNext: { self.serviceLocator.localWall.create(items: $0) })
        .disposed(by: disposeBag)

        searchObservable
            .map { Int($0) ?? 0 }
            .map { self.serviceLocator.localWall.wallItems(for: $0)
                .map { [WallSection(model: "Wall", items: $0)] }
            }
            .map { State.loaded($0) }
            .bind(to: state)
            .disposed(by: disposeBag)
    }

    private func onUpdate(item: WallItem) -> Action<String, Void> {

        return Action { text in
            return self.serviceLocator.networkWall.edit(item: item, text: text)
                .observeOn(MainScheduler.instance)
                .map { _ in self.serviceLocator.localWall.update(wallItem: item, text: text) }
        }
    }
}

extension ParserViewModel {

    enum State {
        case empty
        case loading
        case error
        case loaded(Observable<[WallSection]>)

        var isLoading: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
}
