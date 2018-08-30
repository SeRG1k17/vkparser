//
//  ServiceLocator.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/19/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation

class ServiceLocator {

    let localWall: LocalWallService
    let networkWall: NetworkWallService

    init() {

        let realmClient = RealmClient()
        localWall = LocalWall(client: realmClient)

        let vkDelegate = VKApiDelegate()
        networkWall = NetworkWall(delegate: vkDelegate)
    }

}
