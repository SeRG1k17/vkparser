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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let sceneCoordinator = SceneCoordinator(for: window)
        let vkApi = VKApiDelegate()
        let api = VKApi(vkApiDelegate: vkApi)
        
        let store = Store()
        let parserVM = ParserViewModel(coordinator: sceneCoordinator, vkApiService: api, storeService: store)
        
        sceneCoordinator.transition(to: AppScene.parser(parserVM), type: .root)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app)
        return true
    }
}

