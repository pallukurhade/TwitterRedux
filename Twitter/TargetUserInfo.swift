//
//  TargetUserInfo.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 11/6/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class TargetUserInfo: NSObject {

    var userName: String?
    var userScreenName: String?
    var userImageUrlString: String?
    var userImageUrl: URL?
    
    var userBannerUrlString: String?
    var userBannerImageUrl: URL?
    
    var tweetsCount: Int?
    var fowllowingCount: Int?
    var followersCount: Int?
    
    var userDescription: String?
    
    init(dictionary: NSDictionary) {
        super.init()

        userName = dictionary["name"] as? String
        userScreenName = dictionary["screen_name"] as? String
        
        userImageUrlString = dictionary["profile_image_url"] as? String
        if userImageUrlString != nil {
            userImageUrl = URL(string: userImageUrlString!)
        } else {
            userImageUrl = nil
        }
        
        userBannerUrlString = dictionary["profile_banner_url"] as? String
        if userBannerUrlString != nil {
            userBannerImageUrl = URL(string: userBannerUrlString!)
        } else {
            userBannerImageUrl = nil
        }

        tweetsCount = dictionary["statuses_count"] as? Int
        fowllowingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
        userDescription = dictionary["description"] as? String
    }
}
