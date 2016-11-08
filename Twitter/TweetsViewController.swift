//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 10/30/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

enum TimelineMode: String {
    case Home, Profile, Mentions
}

class TweetsViewController: UIViewController, TweetWriteViewControllerrDelegate, HomeTabelViewObjectDelegate, ProfileTableViewObjectDelegate, MentionsTableViewObjectDelegate {

    var tweets: [Tweet]?
    var targetUserInfo: TargetUserInfo!
    var refreshControl: UIRefreshControl!
    
    var homeTableViewObject: HomeTabelViewObject!
    var profileTableViewObject: ProfileTableViewObject!
    var mentionsTableViewObject: MentionsTableViewObject!

    var currentTimelineMode:TimelineMode! {
        didSet {
            updateTimeline()
        }
    }
    
    @IBOutlet weak var tweetsTableView: UITableView!
    @IBOutlet weak var tweetViewNavigationItem: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tweetsTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120

        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tweetsTableView.insertSubview(refreshControl, at: 0)

        // Set Home as default
        currentTimelineMode = .Home
        loadTweetData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }

    func updateTimeline() {
        if currentTimelineMode == .Home {
            if homeTableViewObject == nil {
                homeTableViewObject = HomeTabelViewObject()
                homeTableViewObject.delegate = self
            }
            
            homeTableViewObject.tweets = tweets
            homeTableViewObject.tableView = tweetsTableView

            tweetsTableView.dataSource = homeTableViewObject
            tweetsTableView.delegate = homeTableViewObject
            
            tweetViewNavigationItem.title = "Home"
        }
        else if currentTimelineMode == .Profile {
            if profileTableViewObject == nil {
                profileTableViewObject = ProfileTableViewObject()
                profileTableViewObject.delegate = self
            }
            
            profileTableViewObject.tweets = tweets
            profileTableViewObject.tableView = tweetsTableView
            
            tweetsTableView.dataSource = profileTableViewObject
            tweetsTableView.delegate = profileTableViewObject
            
            tweetViewNavigationItem.title = "Profile"
        }
        else if currentTimelineMode == .Mentions {
            
            if mentionsTableViewObject == nil {
                mentionsTableViewObject = MentionsTableViewObject()
                mentionsTableViewObject.delegate = self
            }
            
            mentionsTableViewObject.tweets = tweets
            mentionsTableViewObject.tableView = tweetsTableView
            
            tweetsTableView.dataSource = mentionsTableViewObject
            tweetsTableView.delegate = mentionsTableViewObject
            
            tweetViewNavigationItem.title = "Mentions"
        }

        loadTweetData()
    }
    
    func loadTweetData() {
        if currentTimelineMode == .Home {
            TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.homeTableViewObject.tweets = tweets
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }, failure: { (error:Error) -> () in
                print("error: \(error.localizedDescription)")
            })
        }
        else if currentTimelineMode == .Profile {
       
            let currentLoggedinUserID = User.currentUser?.screenName

            TwitterClient.sharedInstance?.userStatus(userId: currentLoggedinUserID!, success: { (userInfo: TargetUserInfo) -> () in
                self.targetUserInfo = userInfo
                self.profileTableViewObject.targetUserInfo = userInfo

                TwitterClient.sharedInstance?.userTweetsTimeLine(userId: currentLoggedinUserID!, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.profileTableViewObject.tweets = tweets
                    self.tweetsTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }, failure: { (error:Error) -> () in
                    print("error: \(error.localizedDescription)")
                })
            }, failure: { (error:Error) -> () in
                print("error: \(error.localizedDescription)")
            })
        }
        else if currentTimelineMode == .Mentions {
            
            TwitterClient.sharedInstance?.mentionsTimeLine(success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
                self.mentionsTableViewObject.tweets = tweets
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }, failure: { (error:Error) -> () in
                print("error: \(error.localizedDescription)")
            })
        }
    }
  
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadTweetData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for seque called")
        
        if segue.identifier == "toTweetDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = tweetsTableView.indexPath(for: cell)
            let tweet = tweets![indexPath!.row]
            let tweetDetailViewController = segue.destination as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet
        }
        else if segue.identifier == "toWriteTweet" {
            let tweetWriteViewController = segue.destination as! TweetWriteViewController
            tweetWriteViewController.delegate = self
        }
    }
    
    func TweetWriteViewController(tweetWriteViewController: TweetWriteViewController, returnedData:AnyObject) {}
    
    func homeTabelViewObject(homeTabelViewObject: HomeTabelViewObject, userScreenName value: String) {
        switchToProfileMode(withUserScreenName: value)
    }
    
    func profileTableViewObject(profileTableViewObject: ProfileTableViewObject, userScreenName value: String) {
        switchToProfileMode(withUserScreenName: value)
    }
    
    func mentionsTableViewObject(mentionsTableViewObject: MentionsTableViewObject, userScreenName value: String) {
        switchToProfileMode(withUserScreenName: value)
    }
    
    func switchToProfileMode(withUserScreenName targetScreenName: String) {
        
        print(targetScreenName)
        
        if User.currentUser?.screenName != targetScreenName {
            if profileTableViewObject == nil {
                profileTableViewObject = ProfileTableViewObject()
                profileTableViewObject.delegate = self
            }
            
            profileTableViewObject.tweets = tweets
            profileTableViewObject.tableView = tweetsTableView
            
            tweetsTableView.dataSource = profileTableViewObject
            tweetsTableView.delegate = profileTableViewObject
            
            TwitterClient.sharedInstance?.userStatus(userId: targetScreenName, success: { (userInfo: TargetUserInfo) -> () in
                self.targetUserInfo = userInfo
                self.profileTableViewObject.targetUserInfo = userInfo
                
                TwitterClient.sharedInstance?.userTweetsTimeLine(userId: targetScreenName, success: { (tweets: [Tweet]) -> () in
                    self.tweets = tweets
                    self.profileTableViewObject.tweets = tweets
                    self.tweetsTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }, failure: { (error:Error) -> () in
                    print("error: \(error.localizedDescription)")
                })
            }, failure: { (error:Error) -> () in
                print("error: \(error.localizedDescription)")
            })
        }
    }
 
}
