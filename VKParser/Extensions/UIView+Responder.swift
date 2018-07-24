//
//  UIView+Responder.swift
//  VKParser
//
//  Created by Sergey on 7/19/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit

extension UIView {
    
    var parentViewController: UIViewController? {
        
        var parentResponder: UIResponder? = self
        
        while let parent = parentResponder {
            
            parentResponder = parent.next
            
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}
