//
//  Tweet.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 10/30/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var isRetweeted:Bool = false

    var userName: String?
    var userScreenName: String?
    var retweeterUserName: String?
    
    var tweetedTimeStamp: NSDate?
    var timeStampString: String?
    var userImageUrlString: String?
    var userImageUrl: URL?
    
    var tweetText: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    var tweetId:String?
    
    var didIRetweeted:Bool?
    var didIFavorited:Bool?
    
    init(dictionary: NSDictionary) {
        super.init()
        //print("-------->>> \(dictionary)")
        
        var tweetData:NSDictionary!
        
        didIRetweeted = dictionary["retweeted"] as? Bool
        didIFavorited = dictionary["favorited"] as? Bool
 
        let retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
        if retweetedStatus != nil {
            isRetweeted = true
            tweetData = retweetedStatus

            let retweetUserData = dictionary["user"] as? NSDictionary
            if retweetUserData != nil {
                retweeterUserName = retweetUserData?["name"]! as? String
            }
            else{
                retweeterUserName = ""
            }
        }
        else {
            isRetweeted = false
            tweetData = dictionary
        }
        
        let userData = tweetData["user"] as? NSDictionary
        if userData != nil {
            userName = userData?["name"]! as? String
            userScreenName = userData?["screen_name"] as? String
            
            userImageUrlString = userData?["profile_image_url"] as? String
            if userImageUrlString != nil {
                userImageUrl = URL(string: userImageUrlString!)
            } else {
                userImageUrl = nil
            }
        }
        
        tweetText = tweetData["text"] as? String
        retweetCount = (tweetData["retweet_count"] as? Int) ?? 0
        favoritesCount = (tweetData["favorite_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MM d HH:mm:ss Z y"
        if let timestampString = timestampString {
            tweetedTimeStamp = formatter.date(from: timestampString) as NSDate?
            timeStampString = tweetedTimeStampToString(tweetedDate: tweetedTimeStamp!)
        }
        
        tweetId = tweetData["id_str"] as? String
    }
    
    class func tweetWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionay in dictionaries {
            let tweet = Tweet(dictionary: dictionay)
            tweets.append(tweet)
        }

        return tweets
    }
    
    func tweetedTimeStampToString(tweetedDate: NSDate) -> String {
        let date = tweetedDate as Date
        let calendar = Calendar.current
        let currentDate = Date()
        
        let yearDiff = calendar.component(.year, from: currentDate) - calendar.component(.year, from: date)
        let monthDiff = calendar.component(.month, from: currentDate) - calendar.component(.month, from: date)
        let dayDiff = calendar.component(.day, from: currentDate) - calendar.component(.day, from: date)
        let hourDiff = calendar.component(.hour, from: currentDate) - calendar.component(.hour, from: date)
        let minutesDiff = calendar.component(.minute, from: currentDate) - calendar.component(.minute, from: date)
        let secondsDiff = calendar.component(.second, from: currentDate) - calendar.component(.second, from: date)
        //print("hours = \(yearDiff):\(monthDiff):\(dayDiff):\(hourDiff):\(minutesDiff):\(secondsDiff)")
        
        if yearDiff > 1 {
            return "over 1yr"
        }
        
        if yearDiff > 0 {
            return String(yearDiff) + "yr"
        }
        
        if monthDiff > 0 {
            return String(monthDiff) + "mo"
        }
        
        if dayDiff >= 7 {
            let value = dayDiff/7
            return String(value) + "w"
        }
        
        if dayDiff > 0 {
            return String(dayDiff) + "d"
        }
        
        if hourDiff > 0 {
            return String(hourDiff) + "h"
        }
        
        if minutesDiff > 0 {
            return String(minutesDiff) + "m"
        }
        
        if secondsDiff > 0 {
            return String(secondsDiff) + "s"
        }
        
        return ""
    }
    
    func updateRetweetStatus(count: Int, retweeted:Bool) {
        retweetCount = retweetCount + count
        didIRetweeted = retweeted
    }
    
    func updateFavoriteStatus(count: Int, favorited:Bool) {
        favoritesCount = favoritesCount + count
        didIFavorited = favorited
    }
    
}
