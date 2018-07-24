//
//  AppScene.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit

enum AppScene: Sceneable {
    
    case parser(ParserViewModel)
    
    var scene: String {
        return "Parser"
    }
    
    var viewController: UIViewController {
        
        switch self {
        case .parser(let vm):
            
            var vc = ParserTableViewController.instance()
            vc.bind(to: vm)
            return UINavigationController(rootViewController: vc)
        }
    }
}
