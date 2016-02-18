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
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
}