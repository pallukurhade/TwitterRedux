//
//  MentionsTableViewObject.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 11/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol MentionsTableViewObjectDelegate {
    @objc optional func mentionsTableViewObject(mentionsTableViewObject: MentionsTableViewObject, userScreenName value: String)
}

class MentionsTableViewObject: NSObject, UITableViewDataSource, UITableViewDelegate, TweetsTableViewCellDelegate {

    var tweets: [Tweet]?
    var tableView:UITableView!
    
    weak var delegate: MentionsTableViewObjectDelegate?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetsTableViewCell", for: indexPath) as! TweetsTableViewCell
        cell.tweet = tweets?[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return (tweets?.count)!
        }
        else {
            return 0
        }
    }
    
    func tweetsTableViewCell(tweetsTableViewCell: TweetsTableViewCell, userScreenName value: String) {
         delegate?.mentionsTableViewObject?(mentionsTableViewObject: self, userScreenName: value)
    }
    
}
