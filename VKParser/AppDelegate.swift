//
//  AppDelegate.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import SwiftyVK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var serviceLocator: ServiceLocator!
    
    private lazy var configurators: [Configurator] = [
        ThirdPartiesConfigurator(),
        RealmMigrationConfigurator(),
        ApplicationConfigurator()
    ]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        configurators.forEach { $0.configure() }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
        
        return true
    }
}

extension AppDelegate {
    
    static var currentDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
}

