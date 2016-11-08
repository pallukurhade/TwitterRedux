//
//  MenuProfileTableViewCell.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 11/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class MenuProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTagLineLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
