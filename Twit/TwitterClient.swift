//
//  TwitterClient.swift
//  Twit
//
//  Created by Lee Edwards on 2/17/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "ASDXfCo26uZTDqC9DK70U8G6B"
let twitterConsumerSecret = "Ekfjc6Y9u5tnAkbqRvJnZGl6Rt6uNXo075lxI9C5n6rKpiAEbd"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithCompletion(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: { (progress: NSProgress) -> Void in },
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray((response as! [NSDictionary]))
                completion(tweets: tweets, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting home timeline")
                    completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void
                in print("success")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error: NSError!) -> Void in
                print("fail")
        })
    }
    
    func openURL(url: NSURL) {
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("access token received")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(requestToken)
            
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    progress: { (progress: NSProgress) -> Void in },
                    success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        print("user: \(User.currentUser!.name)")
                        self.loginCompletion?(user: user, error: nil)
                    },
                    failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                        print("error getting current user")
                        self.loginCompletion?(user: nil, error: error)
                    })
            },
            failure: { (error: NSError!) -> Void in
                print("failed to receive access token")
            }
        )
    }
    
    func createTweetWithCompletion(params: NSDictionary, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json",
            parameters: params,
            progress: { (progress: NSProgress) -> Void in },
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                completion(tweet: tweet, error: nil)
            },
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting home timeline")
                    completion(tweet: nil, error: error)
        })
    }
}