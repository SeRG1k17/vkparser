//
//  WallItemTableViewCell.swift
//  VKParser
//
//  Created by Sergey on 7/13/18.
//  Copyright © 2018 Sergey Pugach. All rights reserved.
//

import UIKit

class WallItemTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textPostLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    @IBOutlet weak var viewsImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
