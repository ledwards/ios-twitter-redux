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
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
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
        if let tweet = self.tweet {
            if tweet.retweeted {
                tweet.retweetCount--
                TwitterClient.sharedInstance.unretweetWithCompletion(tweet.id!) {
                    (responseTweet, error) -> () in
                        if let _ = responseTweet {
                            print("Unretweeted")
                        } else {
                            print(error?.description)
                        }
                    }
            } else {
                tweet.retweetCount++
                TwitterClient.sharedInstance.retweetWithCompletion(tweet.id!) {
                    (responseTweet, error) -> () in
                        if let _ = responseTweet {
                            print("Retweeted")
                        } else {
                            print(error?.description)
                        }
                    }
            }
            tweet.retweeted = !tweet.retweeted
            redrawView()
        }
    }
    
    @IBAction func favoritePressed(sender: AnyObject) {
        if let tweet = self.tweet {
            if tweet.favorited {
                tweet.favoriteCount--
                TwitterClient.sharedInstance.unfavoriteWithCompletion(tweet.id!) {
                    (responseTweet, error) -> () in
                        if let _ = responseTweet {
                            print("Unfavorited")
                        } else {
                            print(error?.description)
                        }
                    }
            } else {
                tweet.favoriteCount++
                TwitterClient.sharedInstance.favoriteWithCompletion(tweet.id!) {
                    (responseTweet, error) -> () in
                        if let _ = responseTweet {
                            print("Favorited")
                            
                        } else {
                            print(error?.description)
                        }
                    }
            }
            tweet.favorited = !tweet.favorited
            redrawView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redrawView()
    }
    
    func redrawView() {
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
            
            self.favoriteButton.setTitle(tweet.favorited ? "Unfavorite": "Favorite", forState: .Normal)
            self.retweetButton.setTitle(tweet.retweeted ? "Unretweet": "Retweet", forState: .Normal)
            
            self.favoriteCountLabel.text = tweet.favoriteCount == 0 ? "" : String(tweet.favoriteCount)
            self.retweetCountLabel.text = tweet.retweetCount == 0 ? "" : String(tweet.retweetCount)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
