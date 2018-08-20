//
//  VKApiDelegate.swift
//  VKParser
//
//  Created by Sergey on 7/19/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import SwiftyVK

class VKApiDelegate: SwiftyVKDelegate {
    
    private struct Constant {
        static let appId = "6637741"
        static let scopes: Scopes = [.messages,.offline,.friends,.wall,.photos,.audio,.video,.docs,.market,.email]
    }
    
    private var token: String? {
        get { return UserDefaults.standard.string(forKey: #function) }
        set { UserDefaults.standard.set(newValue, forKey: #function) }
    }
    
    init() {
        VK.setUp(appId: Constant.appId, delegate: self)
        
        if let token = token {
            try? VK.sessions.default.logIn(rawToken: token, expires: 0)
        } else {
            
            VK.sessions.default.logIn(
                onSuccess: { info in
                    self.token = info["access_token"]
                    print("SwiftyVK: success authorize with", info)
            },
                onError: { error in
                    print("SwiftyVK: authorize failed with", error)
            })
        }
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        // Called when SwiftyVK attempts to get access to user account
        // Should return a set of permission scopes
        return Constant.scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        // Called when SwiftyVK wants to present UI (e.g. webView or captcha)
        // Should display given view controller from current top view controller
        //UIApplication.shared.keyWindow.top
        
        print("vkNeedToPresent")
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootVC.present(viewController, animated: true)
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        // Called when user grants access and SwiftyVK gets new session token
        // Can be used to run SwiftyVK requests and save session data
        //self.token = info["access_token"]
        print("token created in session \(sessionId) with info \(info)")
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        // Called when existing session token has expired and successfully refreshed
        // You don't need to do anything special here
        print("token updated in session \(sessionId) with info \(info)")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        // Called when user was logged out
        // Use this method to cancel all SwiftyVK requests and remove session data
        print("token removed in session \(sessionId)")
    }
}
