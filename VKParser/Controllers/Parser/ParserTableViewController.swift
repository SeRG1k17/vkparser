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

        searchBar.rx.value
            .orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchSubject)
            .disposed(by: rx.disposeBag)

        let stateObservable = viewModel.state
            .asObservable()
            .share()

        stateObservable
            .subscribe(onNext: tableManager.setUpDataSource(by:))
            .disposed(by: rx.disposeBag)

        stateObservable
            .map { $0.isLoading }
            .asDriver(onErrorJustReturn: false)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: rx.disposeBag)

        bind(tableManager)
    }

    private func bind(_ tableManager: ParserTableManager) {

        tableManager.itemDeleted
            .subscribe(viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)

        tableManager.editItem
            .subscribe(viewModel.editAction.inputs)
            .disposed(by: rx.disposeBag)
    }

    private func setUp(_ searchBar: UISearchBar) {

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
