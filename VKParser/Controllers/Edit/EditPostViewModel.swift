//
//  EditPostViewModel.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/27/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct EditPostViewModel {
    
    let itemText: String
    let onDone: Action<String, Void>
    let onCancel: CocoaAction!
    
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
    init(coordinator: SceneCoordinatorType, item: WallItem, doneAction: Action<String, Void>, cancelAction: CocoaAction? = nil) {
        
        self.itemText = item.text
        self.sceneCoordinator = coordinator
        self.onDone = doneAction
        
        onCancel = CocoaAction {
            cancelAction?.execute(())
            return coordinator.pop()
        }
        
        onDone.executionObservables
            .subscribe(onNext: { _ in
                coordinator.pop()
            })
            .disposed(by: disposeBag)
    }
}
