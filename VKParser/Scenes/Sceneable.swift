//
//  Sceneable.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit

protocol Sceneable {

    var scene: String { get }
    var viewController: UIViewController { get }
}
