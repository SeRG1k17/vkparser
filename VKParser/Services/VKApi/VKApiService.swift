//
//  VKApiService.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import Foundation
import SwiftyVK
import RxSwift

protocol VKApiService {
    
    var vkApiDelegate: SwiftyVKDelegate { get set }
    func wallItems(for userId: String) -> Observable<[WallItem]>
}
