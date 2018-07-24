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

class ParserTableViewController: UITableViewController, BindableType, TableDataSourceable {
    
    typealias ViewModelType = ParserViewModel
    var viewModel: ParserViewModel!
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        navigationItem.titleView = bar
        return bar
    }()
    
    typealias SectionType = WallSection
    typealias CellType = WallItemTableViewCell
    
    lazy var dataSource: AnimatableTableDataSource = {
        return AnimatableTableDataSource(configureCell: { [weak self] source, tableView, indexPath, item -> CellType in

            guard let `self` = self else { return CellType() }
            return self.dequeue(tableView: tableView, indexPath: indexPath, item: item)
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        CellType.registerNib(for: tableView)
        
        setUp(searchBar)
        configure(dataSource)
        
        //refreshControl.rx.isRefreshi
    }
    
    func bindViewModel() {
        
        searchBar.rx.text
            .orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                self?.viewModel.onChanged(value)
            })
            .disposed(by: rx.disposeBag)
        
        
        /*
        searchBar.rx.text.orEmpty.subscribe(onNext: { value in
            print(value)
        })
        .disposed(by: rx.disposeBag)
 */
        
        viewModel.sectionedItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        
        tableView.rx.itemDeleted
            .map { [unowned self] indexPath in
                try self.tableView.rx.model(at: indexPath)
            }
            .subscribe(viewModel.deleteAction.inputs)
            .disposed(by: rx.disposeBag)
        
        //searchBar.rx.text.orEmpty
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
                self.searchBar.text = String()
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
    
    func configure(_ dataSource: AnimatableTableDataSource) {
        dataSource.canEditRowAtIndexPath = { _,_  in true }
    }
    
    func configureCell(_ cell: CellType, by item: SectionType.Item) {
        cell.titleLabel.text = item.title
    }
}

