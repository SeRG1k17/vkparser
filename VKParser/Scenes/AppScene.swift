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
    case editPost(EditPostViewModel)
    
    var scene: String {
        switch self {
        case .parser: return "Parser"
        case .editPost: return "EditPost"
        }
    }
    
    var viewController: UIViewController {
        
        switch self {
        case .parser(let vm):
            
            var vc = ParserTableViewController.instance()
            vc.bind(to: vm)
            //vm.tableManager = ParserTableManager(tableView: vc.tableView)
            return UINavigationController(rootViewController: vc)
            
        case .editPost(let vm):
            var vc = EditPostViewController.instance()
            vc.bind(to: vm)
            return UINavigationController(rootViewController: vc)
        }
    }
}
