//
//  EditPostViewController.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/27/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController, BindableType {

    @IBOutlet weak var editTextView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    typealias ViewModelType = EditPostViewModel
    var viewModel: EditPostViewModel!
    
    func bindViewModel() {
        
        editTextView.text = viewModel.itemText
        
        cancelButton.rx.action = viewModel.onCancel
        
        doneButton.rx.tap
            .withLatestFrom(editTextView.rx.text.orEmpty)
            .subscribe(viewModel.onDone.inputs)
            .disposed(by: rx.disposeBag)
    }

}
