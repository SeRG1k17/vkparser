//
//  AnimatedTableDataSourceable.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

protocol AnimatedTableDataSourceable: class {
    
    associatedtype SectionType: AnimatableSectionModelType
    typealias AnimatableTableDataSource = RxTableViewSectionedAnimatedDataSource<SectionType>
    
    var dataSource: AnimatableTableDataSource { get set }
    
    associatedtype CellType: UITableViewCell
    
    func configure(_ dataSource: AnimatableTableDataSource)
    func dequeue(tableView: UITableView, indexPath: IndexPath, item: SectionType.Item) -> CellType
    func configureCell(_ cell: CellType, by item: SectionType.Item)
}

extension AnimatedTableDataSourceable {
    
    func dequeue(tableView: UITableView, indexPath: IndexPath, item: SectionType.Item) -> CellType {
        
        let cell = CellType.dequeue(from: tableView, for: indexPath)
        configureCell(cell, by: item)
        
        return cell
    }
}
