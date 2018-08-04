//
//  StoreServiceError.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation

enum StoreServiceError: Error {
    
    case save(WallItem)
    case saveArray([WallItem])
    case delete(WallItem)
}
