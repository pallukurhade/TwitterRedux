//
//  ProfileTableViewCell.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 11/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!

    var targetUserInfo: TargetUserInfo! {
        didSet {
            if targetUserInfo.userBannerImageUrl != nil {
                bannerImage.setImageWith(targetUserInfo.userBannerImageUrl!, placeholderImage: nil)
                bannerImage.isHidden = false
            }
            else {
                bannerImage.isHidden = true
            }
            userImage.setImageWith(targetUserInfo.userImageUrl!, placeholderImage: nil)
 
            userNameLabel.text = targetUserInfo.userName
            screenNameLabel.text = targetUserInfo.userScreenName
            
            tweetsCountLabel.text = String(describing: targetUserInfo.tweetsCount!)
            followingCountLabel.text = String(describing: targetUserInfo.fowllowingCount!)
            followersCountLabel.text = String(describing: targetUserInfo.followersCount!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.cornerRadius = 6
        userImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
