//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 10/30/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking
import Foundation

@objc protocol TweetsTableViewCellDelegate {
    @objc optional func tweetsTableViewCell(tweetsTableViewCell: TweetsTableViewCell, userScreenName value: String)
}

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var retweetedByIcon: UIImageView!

    @IBOutlet weak var retweetIcon: UIImageView!
    @IBOutlet weak var retweetIconOn: UIImageView!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var likeIconOn: UIImageView!
    
    @IBOutlet weak var nameRetweetedByLabel: UILabel!
    
    @IBOutlet weak var tweeterImage: UIImageView!
    @IBOutlet weak var tweeterNameLabel: UILabel!
    @IBOutlet weak var tweeterScreenNameLabel: UILabel!

    @IBOutlet weak var tweetedTimeLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    
    @IBOutlet weak var reweetedCountLabel: UILabel!
    @IBOutlet weak var likedCountLabel: UILabel!
    
    weak var delegate: TweetsTableViewCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            if tweet.isRetweeted {
                retweetedByIcon.isHidden = false
                nameRetweetedByLabel.isHidden = false
                nameRetweetedByLabel.text = tweet.retweeterUserName! + " Retweeted"
                
                //TODO: set height to 0
            }
            else{
                retweetedByIcon.isHidden = true
                nameRetweetedByLabel.isHidden = true
                nameRetweetedByLabel.text = ""
                
                //TODO: set height to original
            }
            
            tweetsLabel.text = tweet.tweetText
            
            tweeterImage.setImageWith(tweet.userImageUrl!, placeholderImage: nil)
            tweeterNameLabel.text = tweet.userName
            tweeterScreenNameLabel.text = "@" + tweet.userScreenName!
            
            tweetedTimeLabel.text = tweet.timeStampString
            
            reweetedCountLabel.text = String(tweet.retweetCount)
            likedCountLabel.text = String(tweet.favoritesCount)
            
            if tweet.didIRetweeted! != true {
                retweetIcon.isHidden = false
                retweetIconOn.isHidden = true
            }
            else {
                retweetIcon.isHidden = true
                retweetIconOn.isHidden = false
            }
            
            if tweet.didIFavorited! != true {
                likeIcon.isHidden = false
                likeIconOn.isHidden = true
            }
            else {
                likeIcon.isHidden = true
                likeIconOn.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        tweeterImage.layer.cornerRadius = 6
        tweeterImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetsTableViewCell.userImageTapped))
        tapGesture.delegate = self;
        tweeterImage.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func userImageTapped() {
        print("tweet.userScreenName == \(tweet.userScreenName)")
        delegate?.tweetsTableViewCell?(tweetsTableViewCell: self, userScreenName: tweet.userScreenName!)
    }
}
