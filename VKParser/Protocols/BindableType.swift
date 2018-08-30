//
//  BindableType.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit

protocol BindableType {

    associatedtype ViewModelType

    var viewModel: ViewModelType! { get set }
    func bindViewModel()
    //func bindViewModel(to model: Self.ViewModelType?)
}

extension BindableType where Self: UIViewController {

    mutating func bind(to model: Self.ViewModelType) {

        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
