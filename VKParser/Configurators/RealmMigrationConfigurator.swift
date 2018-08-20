//
//  RealmMigrationConfigurator.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/19/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMigrationConfigurator: Configurator {
    
    func configure() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)
    }
    
}
