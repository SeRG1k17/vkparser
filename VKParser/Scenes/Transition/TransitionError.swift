//
//  TransitionError.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit

enum TransitionError: Error {
    case instance
    case push
    case pop(UIViewController?)
    case modal(UIViewController?)
}

extension TransitionError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .instance: return "Can't get a scene instance"
        case .push: return "Can't push a view controller without a current navigation controller"
        case .pop(let vc): return "Can't navigate back from \(String(describing: vc))"
        case .modal(let vc): return "Not a modal, no navigation controller: can't navigate back from \(String(describing: vc))"
        }
    }
}
