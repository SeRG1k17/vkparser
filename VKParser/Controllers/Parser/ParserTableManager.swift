//
//  ParserTableManager.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/18/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import RxSwift
import NSObject_Rx
import RxDataSources
import Kingfisher

class ParserTableManager: NSObject, TableDataSourceable {

    typealias SectionType = WallSection
    typealias CellType = WallItemTableViewCell
    
    weak var tableView: UITableView! {
        didSet {
            setUp(tableView)
        }
    }
    
    lazy var dataSource: AnimatableTableDataSource = {
        return AnimatableTableDataSource(configureCell: { [weak self] source, tableView, indexPath, item -> CellType in
            
            guard let `self` = self else { return CellType() }
            return self.dequeue(tableView: tableView, indexPath: indexPath, item: item)
        })
    }()
    
    init(tableView: UITableView) {
        
        defer { self.tableView = tableView }
        super.init()
    }
    
    var itemDeleted: Observable<WallItem> {
        return tableView.rx.itemDeleted
            .map { [unowned self] indexPath in
                try self.tableView.rx.model(at: indexPath)
        }
    }
    
    func setUp(_ tableView: UITableView) {
        
        CellType.registerNib(for: tableView)
        
        configure(dataSource)
        tableView.tableFooterView = UIView()
    }
    
    func setUpDataSource(by state: ParserViewModel.State) {
        
        var items: [WallSection] = []
        if case let .loaded(loaded) = state {
            
            loaded
            .bind(to: tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: rx.disposeBag)
        }
        
//        Observable.from(optional: items)
//            .bind(to: tableView.rx.items(dataSource: self.dataSource))
//            .disposed(by: rx.disposeBag)
    }
    
    func configure(_ dataSource: AnimatableTableDataSource) {
        dataSource.canEditRowAtIndexPath = { _,_  in true }
    }
    
    func configureCell(_ cell: CellType, by item: SectionType.Item) {
        
        if let url = URL(string: item.authorPhoto) {
            cell.authorImageView.kf.setImage(with: url)
        }
        
        cell.authorNameLabel.text = item.authorName
        
        cell.dateLabel.text = DateFormatter.parseFormatter.string(from: item.date)
        cell.textPostLabel.text = item.text
        cell.likeCountLabel.text = String(item.likesCount)
        cell.repostCountLabel.text = String(item.repostsCount)
        cell.commentCountLabel.text = String(item.commentsCount)
        cell.viewsCountSubject.onNext(item.viewsCount.value.map { String($0) })
    }
}

private extension DateFormatter {
    
    static let parseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
