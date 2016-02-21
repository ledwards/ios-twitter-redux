//
//  DetailViewController.swift
//  Twit
//
//  Created by Lee Edwards on 2/19/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var tweet: Tweet?
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var metaLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func backPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func replyTopPressed(sender: AnyObject) {
        composeReply()
    }
    
    @IBAction func replyPressed(sender: AnyObject) {
        composeReply()
    }
    
    func composeReply() {
        if let tweet = tweet {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("ComposeTweetViewController") as! ComposeTweetViewController!
            navigationController?.pushViewController(vc, animated: true)
            vc.replyToID = tweet.id
            vc.replyToUsername = tweet.user?.screenname
        }
    }
    
    @IBAction func retweetPressed(sender: AnyObject) {
        self.retweetButton.setTitle("Retweet", forState: .Normal)
        if tweet!.retweeted {
            TwitterClient.sharedInstance.unretweetWithCompletion(tweet!.id!) {
                (tweet, error) -> () in
                    if let tweet = tweet {
                        print("Unretweeted")
                        self.tweet?.retweeted = tweet.retweeted
                    } else {
                        print(error?.description)
                    }
                }
        } else {
            self.retweetButton.setTitle("Unretweet", forState: .Normal)
            TwitterClient.sharedInstance.retweetWithCompletion(tweet!.id!) {
                (tweet, error) -> () in
                    if let tweet = tweet {
                        print("Retweeted")
                        self.tweet?.retweeted = tweet.retweeted
                    } else {
                        print(error?.description)
                    }
                }
        }
    }
    
    @IBAction func favoritePressed(sender: AnyObject) {
        if tweet!.favorited {
            self.favoriteButton.setTitle("Favorite", forState: .Normal)
            TwitterClient.sharedInstance.unfavoriteWithCompletion(tweet!.id!) {
                (tweet, error) -> () in
                    if let tweet = tweet {
                        print("Unfavorited")
                        self.tweet?.favorited = tweet.favorited
                    } else {
                        print(error?.description)
                    }
                }
        } else {
            self.favoriteButton.setTitle("Unfavorite", forState: .Normal)
            TwitterClient.sharedInstance.favoriteWithCompletion(tweet!.id!) {
                (tweet, error) -> () in
                    if let tweet = tweet {
                        print("Favorited")
                        self.tweet?.favorited = tweet.favorited
                    } else {
                        print(error?.description)
                    }
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tweet = tweet {
            profileImageView.af_setImageWithURL(NSURL(string: (tweet.user?.profileImageURL)!)!)
            nameLabel.text = tweet.user?.name
            usernameLabel.text = "@\(tweet.user!.screenname!)"
            descriptionLabel.text = tweet.text
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy, HH:MM"
            timestampLabel.text = dateFormatter.stringFromDate(tweet.createdAt!)
            if let replyTo = tweet.inReplyToUsername {
                metaLabel.text = "in reply to \(replyTo)"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
