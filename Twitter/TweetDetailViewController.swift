//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 10/30/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var retweetedIcon: UIImageView!
    @IBOutlet weak var nameRetweetedByLabel: UILabel!
    @IBOutlet weak var tweeterImage: UIImageView!
    @IBOutlet weak var tweeterNameLabel: UILabel!
    @IBOutlet weak var tweeterScreenNameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var tweetedTimeLabel: UILabel!
    @IBOutlet weak var retweetedAndLikedLabel: UILabel!

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetOnButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteOnButon: UIButton!
    
    var tweet: Tweet!
    
    @IBAction func onReplyButton(_ sender: AnyObject) {
        
    }
    
    @IBAction func onRetweetButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.sendRetweet(targetId: tweet.tweetId!, success: {() -> Void in
                self.tweet.updateRetweetStatus(count:1, retweeted:true)
                self.updateIcons()
            }, failure: {(error:Error) -> Void in
                self.updateIcons()
                print("Error:\(error.localizedDescription)")
        })  
        updateIcons()
    }
    
    @IBAction func onRetweetOnButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.sendUnretweet(targetId: tweet.tweetId!, success: {() -> Void in
                self.tweet.updateRetweetStatus(count:-1, retweeted:false)
                self.updateIcons()
            }, failure: {(error:Error) -> Void in
                self.updateIcons()
                print("Error:\(error.localizedDescription)")
        })
    }
    
    @IBAction func onFavoriteButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.sendFavorite(targetId: tweet.tweetId!, success: {() -> Void in
                self.tweet.updateFavoriteStatus(count:1, favorited:true)
                self.updateIcons()
            }, failure: { (error: Error) in

                self.updateIcons()
                print("Error:\(error.localizedDescription)")
        })
    }
    
    @IBAction func onFavoriteOnButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.sendUnfavorite(targetId: tweet.tweetId!, success: {() -> Void in
                self.tweet.updateFavoriteStatus(count:11, favorited:false)
                self.updateIcons()
            }, failure: { (error: Error) in
                self.updateIcons()
                print("Error:\(error.localizedDescription)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tweet = self.tweet{
            if tweet.isRetweeted {
                retweetedIcon.isHidden = false
                nameRetweetedByLabel.isHidden = false
                nameRetweetedByLabel.text = tweet.retweeterUserName! + " Retweeted"
                
                //TODO: set height to 0
            }
            else{
                retweetedIcon.isHidden = true
                nameRetweetedByLabel.isHidden = true
                nameRetweetedByLabel.text = ""
                
                //TODO: set height to original
            }
            
            tweetLabel.text = tweet.tweetText
            
            tweeterImage.setImageWith(tweet.userImageUrl!, placeholderImage: nil)
            tweeterNameLabel.text = tweet.userName
            tweeterScreenNameLabel.text = "@" + tweet.userScreenName!
            
            tweetedTimeLabel.text = tweet.timeStampString
            
            let retweetCountText:String?
            if tweet.retweetCount > 0 {
                retweetCountText = String(tweet.retweetCount) + " RETWEETS"
            }
            else if tweet.retweetCount == 1 {
                retweetCountText = "1 RETWEET"
            }
            else {
                retweetCountText = ""
            }
            
            let likedCountText:String?
            if tweet.favoritesCount > 0 {
                likedCountText = String(tweet.favoritesCount) + " LIKE"
            }
            else if tweet.favoritesCount == 1 {
                likedCountText = "1 LIKE"
            }
            else {
                likedCountText = ""
            }
            
            if retweetCountText != "" {
                retweetedAndLikedLabel.text = retweetCountText! + " " + likedCountText!
            }
            else {
                retweetedAndLikedLabel.text = likedCountText
            }
            
            updateIcons()
        }
        else {
            print("ERROR: tweet data hasn't been passed to TweetDetailViewController.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation toReplyView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReplyView" {
            let targetViewController = segue.destination as! ReplyViewController
            targetViewController.tweet = self.tweet
        }
        else if segue.identifier == "toTweetDetail"  {
            print("unwind to toTweetDetail")
        }
    }
    
    func updateIcons () {
        if tweet.didIRetweeted == true {
            retweetButton.isHidden = true
            retweetButton.isEnabled = false
            retweetOnButton.isHidden = false
            retweetOnButton.isEnabled = true
        }
        else {
            retweetButton.isHidden = false
            retweetButton.isEnabled = true
            retweetOnButton.isHidden = true
            retweetOnButton.isEnabled = false
        }
        
        if tweet.didIFavorited == true {
            favoriteButton.isHidden = true
            favoriteButton.isEnabled = false
            favoriteOnButon.isHidden = false
            favoriteOnButon.isEnabled = true
        }
        else {
            favoriteButton.isHidden = false
            favoriteButton.isEnabled = true
            favoriteOnButon.isHidden = true
            favoriteOnButon.isEnabled = false
        }
    }
}
