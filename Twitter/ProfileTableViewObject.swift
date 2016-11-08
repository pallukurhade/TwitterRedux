//
//  ProfileTableViewObject.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 11/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol ProfileTableViewObjectDelegate {
    @objc optional func profileTableViewObject(profileTableViewObject: ProfileTableViewObject, userScreenName value: String)
}

class ProfileTableViewObject: NSObject, UITableViewDataSource, UITableViewDelegate, TweetsTableViewCellDelegate {

    var targetUserInfo: TargetUserInfo!
    var tweets: [Tweet]?
    var tableView:UITableView!
    
    weak var delegate: ProfileTableViewObjectDelegate?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell!
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            
            if targetUserInfo != nil {
                (cell as! ProfileTableViewCell).targetUserInfo = targetUserInfo
            }
        }
        else {
            cell = tableView.dequeueReusableCell(withIdentifier: "TweetsTableViewCell", for: indexPath) as! TweetsTableViewCell
            (cell as! TweetsTableViewCell).delegate = self
            (cell as! TweetsTableViewCell).tweet = tweets?[indexPath.row - 1]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return ((tweets?.count)! + 1)
        }
        else {
            return 0
        }
    }
    
    func tweetsTableViewCell(tweetsTableViewCell: TweetsTableViewCell, userScreenName value: String) {
        delegate?.profileTableViewObject?(profileTableViewObject: self, userScreenName: value)
    }
}
