//
//  WallItemTableViewCell.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class WallItemTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textPostLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var repostCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var viewsImageView: UIImageView!
    
    var viewsCountSubject = PublishSubject<String?>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let viewsCountDriver = viewsCountSubject
            .asDriver(onErrorJustReturn: nil)
            
            viewsCountDriver
            .drive(viewsCountLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        viewsCountDriver
            .map { ($0 ?? "").isEmpty }
            .drive(viewsImageView.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
}
