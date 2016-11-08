//
//  HomeTabelViewObject.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 11/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol HomeTabelViewObjectDelegate {
    @objc optional func homeTabelViewObject(homeTabelViewObject: HomeTabelViewObject, userScreenName value: String)
}

class HomeTabelViewObject: NSObject, UITableViewDataSource, UITableViewDelegate, TweetsTableViewCellDelegate {
    
    var tweets: [Tweet]?
    var tableView:UITableView!
    
    weak var delegate: HomeTabelViewObjectDelegate?

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
        delegate?.homeTabelViewObject?(homeTabelViewObject: self, userScreenName: value)
    } 
}
