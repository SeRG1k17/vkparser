//
//  RealmClientError.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmClientError<T: Object>: Error {
    
    case create(T)
    case fetch
    case update(T)
    case updateMany([T])
    case delete(T)
}
