//
//  COFeedCell.swift
//  COReddit
//
//  Created by Matthew Sun on 10/10/15.
//  Copyright © 2015 Matthew Sun. All rights reserved.
//

import UIKit

class COFeedCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    var postID : String?
}
