//
//  ParserTableManager.swift
//  VKParser
//
//  Created by Sergey Pugach on 8/18/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Kingfisher
import Action

class ParserTableManager: AnimatedTableDataSourceable {

    typealias SectionType = WallSection
    typealias CellType = WallItemTableViewCell

    weak var tableView: UITableView! {
        didSet {
            setUp(tableView)
        }
    }

    private let disposeBag = DisposeBag()

    lazy var dataSource: AnimatableTableDataSource = {
        return AnimatableTableDataSource(configureCell: { [weak self] _, tableView, indexPath, item -> CellType in

            guard let `self` = self else { return CellType() }
            return self.dequeue(tableView: tableView, indexPath: indexPath, item: item)
        })
    }()

    var itemDeleted: Observable<WallItem> {
        return tableView.rx.itemDeleted
            .map { [unowned self] indexPath in
                try self.tableView.rx.model(at: indexPath)
        }
    }

    let editItem = PublishSubject<WallItem>()

    init(tableView: UITableView) {

        defer { self.tableView = tableView }
    }

    func setUp(_ tableView: UITableView) {

        CellType.registerNib(for: tableView)

        configure(dataSource)
        tableView.tableFooterView = UIView()
    }

    func setUpDataSource(by state: ParserViewModel.State) {

//        var items: [WallSection] = []
        if case let .loaded(loaded) = state {

            loaded
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        }

//        Observable.from(optional: items)
//            .bind(to: tableView.rx.items(dataSource: self.dataSource))
//            .disposed(by: rx.disposeBag)
    }

    func configure(_ dataSource: AnimatableTableDataSource) {

        dataSource.canEditRowAtIndexPath = { source, indexPath in

            return source.sectionModels[indexPath.section]
                .items[indexPath.row]
                .canDelete
        }
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

        cell.editButton.isHidden = !item.canEdit
        cell.editButton.rx.action = CocoaAction { [weak self] in
            self?.editItem.onNext(item)
            return .empty()
        }
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
