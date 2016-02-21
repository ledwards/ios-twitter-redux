//
//  Tweet.swift
//  Twit
//
//  Created by Lee Edwards on 2/18/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var inReplyToUsername: String?
    var retweeted: Bool
    var retweetCount: Int
    var favorited: Bool
    var favoriteCount: Int
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: (dictionary["user"] as! NSDictionary))
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id"] as? Int
        inReplyToUsername = dictionary["in_reply_to_screen_name"] as? String
        retweeted = dictionary["retweeted"] as? Bool ?? false
        favorited = dictionary["favorited"] as? Bool ?? false
        retweetCount = dictionary["retweet_count"] as? Int ?? 0
        favoriteCount = dictionary["favourites_count"] as? Int ?? 0
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
