//
//  TwitterClient.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 10/30/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

struct LoginInfo {
    static let TWITTER_URL_STRING = "https://api.twitter.com"
    static let COMSUMER_KEY = "JQFnQdko027blgr8ASYwDomk2"
    static let COSUMER_SECRET = "ow3guPbqhATyLOh1Wew6beQszOVCQLOxRvbC71IpHOnDzjj4WV"
    static let REQUEST_TOKEN_URL = "oauth/request_token"
    static let AUTHORIZE_URL = "https://api.twitter.com/oauth/authorize"
    static let ACCESS_TOKEN_URL = "oauth/access_token"
    
    static let VERIFY_CREDENTIAL_URL = "1.1/account/verify_credentials.json"
    static let HOME_TIMELINE_URL = "1.1/statuses/home_timeline.json"
    static let USER_STATUS_URL = "1.1/users/show.json?screen_name="
    static let USER_TIMELINE_URL = "1.1/statuses/user_timeline.json?screen_name="
    static let MENTIONS_TIMELINE_URL = "1.1/statuses/mentions_timeline.json"
    
    static let RETWEET_URL_PREFIX = "1.1/statuses/retweet/"
    static let UNRETWEET_URL_PREFIX = "1.1/statuses/unretweet/"
    static let RETWEET_URL_SUFFIX = ".json"
    
    static let STATUS_UPDATE_URL = "1.1/statuses/update.json?"
    
    static let FAVORITE_URL_PREFIX = "1.1/favorites/create.json?id="
    static let UNFAVORITE_URL_PREFIX = "1.1/favorites/destroy.json?id="
}

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string: LoginInfo.TWITTER_URL_STRING), consumerKey: LoginInfo.COMSUMER_KEY, consumerSecret: LoginInfo.COSUMER_SECRET)
 
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure

        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: LoginInfo.REQUEST_TOKEN_URL, method: "GET", callbackURL: URL(string: "codepathtwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            let tokenString:String = (requestToken?.token)! as String
            let url = URL(string: LoginInfo.AUTHORIZE_URL + "?oauth_token=" + tokenString)!
            UIApplication.shared.open(url)
        }, failure: { (error:Error?) -> Void in
            print("Request Token Failed. - error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl (url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: LoginInfo.ACCESS_TOKEN_URL, method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential?) -> Void in
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                
            }, failure: { (error: Error) -> () in
                    
                self.loginFailure?(error)
            })

        }, failure: { (error:Error?) -> Void in
            print("Request Access Token Failed. - error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }

    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get(LoginInfo.HOME_TIMELINE_URL, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, resposne: Any?) -> Void in
            let dictionaries = resposne as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            
                success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
                failure(error)
        })
    }
    
    func userStatus(userId: String, success: @escaping (TargetUserInfo) -> (), failure: @escaping (Error) -> ()) {
        let encodedUserIdString = userId.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let userStatusURLString:String = LoginInfo.USER_STATUS_URL + encodedUserIdString!
        
        get(userStatusURLString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, resposne: Any?) -> Void in
            let dictionay = resposne as! NSDictionary
            let targetUserInfo = TargetUserInfo(dictionary: dictionay)

            success(targetUserInfo)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }

    func userTweetsTimeLine(userId: String, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        let encodedUserIdString = userId.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let userTimelineURLString:String = LoginInfo.USER_TIMELINE_URL + encodedUserIdString!

        get(userTimelineURLString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, resposne: Any?) -> Void in
            let dictionaries = resposne as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }
    
    func mentionsTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get(LoginInfo.MENTIONS_TIMELINE_URL, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, resposne: Any?) -> Void in
            let dictionaries = resposne as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionaries)
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })
    }

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get(LoginInfo.VERIFY_CREDENTIAL_URL, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
            print("Request Access Token Failed. - error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func sendTweet(tweetString: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let encodedTweetString = tweetString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let tweetURLString:String = LoginInfo.STATUS_UPDATE_URL + "status=" + encodedTweetString!
        
        post(tweetURLString, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
            print("Send Tweet Failed. - error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func sendReplyTweet(targetId: String, statusString: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let encodedStatusString = statusString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let replyTweetURLString:String = LoginInfo.STATUS_UPDATE_URL + "status=" + encodedStatusString! + "&in_reply_to_status_id=" + targetId

        post(replyTweetURLString, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
            print("Send Reply Failed. - error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func sendRetweet(targetId: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let retweetURLString:String = LoginInfo.RETWEET_URL_PREFIX + targetId + LoginInfo.RETWEET_URL_SUFFIX

        post(retweetURLString, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
            print("Send Retweet Failed. - error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func sendUnretweet(targetId: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let unretweetURLString:String = LoginInfo.UNRETWEET_URL_PREFIX + targetId + LoginInfo.RETWEET_URL_SUFFIX
        
        post(unretweetURLString, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
            print("Send UNretweet Failed. - error: \(error.localizedDescription)")
            failure(error)
        })
    }
 
    func sendFavorite(targetId: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let favoriteURLString:String = LoginInfo.FAVORITE_URL_PREFIX + targetId
        
        post(favoriteURLString, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
            print("Send Favorite Failed. - error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    func sendUnfavorite(targetId: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let unfavoriteURLString:String = LoginInfo.UNFAVORITE_URL_PREFIX + targetId
        
        post(unfavoriteURLString, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, response: Any?) -> Void in
            success()
        }, failure: { (task:URLSessionDataTask?, error:Error) -> Void in
            print("Send Unfavorite Failed. - error: \(error.localizedDescription)")
            failure(error)
        })
    }

}
