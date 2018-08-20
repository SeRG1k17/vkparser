//
//  ThirdPartiesConfigurator.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/18/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift

class ThirdPartiesConfigurator: Configurator {
    
    func configure() {
        configureKeyboardManager()
    }
    
    private func configureKeyboardManager(_ manager: IQKeyboardManager = IQKeyboardManager.shared) {
        
        manager.enable = true
        manager.enableAutoToolbar = false
        manager.shouldResignOnTouchOutside = true
    }
}
