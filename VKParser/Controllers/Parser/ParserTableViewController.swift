//
//  ParserTableViewController.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Action

class ParserTableViewController: UITableViewController, BindableType {
    
    typealias ViewModelType = ParserViewModel
    var viewModel: ParserViewModel!
    
    lazy var activityIndicator: UIActivityIndicatorView! = {
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        tableView.backgroundView = indicator
        return indicator
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        navigationItem.titleView = bar
        return bar
    }()
    
    lazy var tableManager = ParserTableManager(tableView: tableView)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp(searchBar)
    }
    
    func bindViewModel() {

        //searchBar.rx.text
        searchBar.rx.value
            .orEmpty
            //.debounce(0.5, scheduler: MainScheduler.instance)
            .throttle(0.5, scheduler: MainScheduler.instance)
            //.distinctUntilChanged()
            .bind(to: viewModel.searchVariable)
            .disposed(by: rx.disposeBag)
        
        let stateObservable = viewModel.state
            .asObservable()
            .share()
        
//        viewModel.sectionedItems
//            .bind(to: tableView.rx.items(dataSource: tableManager.dataSource))
//            .disposed(by: rx.disposeBag)
        
        stateObservable
            .subscribe(onNext: tableManager.setUpDataSource(by:))
            .disposed(by: rx.disposeBag)
        
        stateObservable
            //.skip(1)
            .map { $0.isLoading }
            .asDriver(onErrorJustReturn: false)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: rx.disposeBag)

        tableManager.itemDeleted
            .subscribe(onNext: viewModel.delete(item:))
            //.subscribe(viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
    }
    
    func setUp(_ searchBar: UISearchBar) {
        
        searchBar.tintColor = .black
        searchBar.placeholder = "Search"
        
        searchBar.rx.textDidBeginEditing
            .subscribe(onNext: { [weak self] _ in
            self?.searchBar.setShowsCancelButton(true, animated: true)
        })
        .disposed(by: rx.disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] _ in
                
                guard let `self` = self else { return }
                self.searchBar.setShowsCancelButton(false, animated: true)
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: rx.disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] _ in
                
                guard let `self` = self else { return }
                self.searchBar.setShowsCancelButton(false, animated: true)
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: rx.disposeBag)
    }
}

