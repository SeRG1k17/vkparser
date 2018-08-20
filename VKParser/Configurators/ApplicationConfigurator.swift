//
//  ApplicationConfigurator.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/19/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation

class ApplicationConfigurator: Configurator {
    
    let appDelegate = AppDelegate.currentDelegate
    
    func configure() {
        
        let serviceLocator = ServiceLocator()
        appDelegate?.serviceLocator = serviceLocator
        
        let sceneCoordinator = SceneCoordinator(for: appDelegate?.window)
        let parserVM = ParserViewModel(coordinator: sceneCoordinator,
                                       serviceLocator: serviceLocator)
        
        let scene = AppScene.parser(parserVM)
        scene.viewController
        
        sceneCoordinator.transition(to: AppScene.parser(parserVM), type: .root)
    }
    
}
