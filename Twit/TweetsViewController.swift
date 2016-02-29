//
//  TweetsViewController.swift
//  Twit
//
//  Created by Lee Edwards on 2/18/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit
import AlamofireImage

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var mentions: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        populateTweets()
        
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshCallback:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    @IBAction func replyPressed(sender: AnyObject) {
        let tweet = tweets![sender.tag]
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ComposeTweetViewController") as! ComposeTweetViewController!
        navigationController?.pushViewController(vc, animated: true)
        vc.replyToID = tweet.id
        vc.replyToUsername = tweet.user?.screenname
    }
    
    @IBAction func retweetPressed(sender: AnyObject) {
        let button = sender as! UIButton
        let tweet = tweets![button.tag]
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
        button.setTitle(tweet.retweeted ? "Unretweet": "Retweet", forState: .Normal)
        self.tableView.reloadData()
    }
    
    @IBAction func favoritePressed(sender: AnyObject) {
        let button = sender as! UIButton
        let tweet = tweets![button.tag]
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
        button.setTitle(tweet.favorited ? "Unfavorite": "Favorite", forState: .Normal)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        print("logout button pressed")
    }
    
    func refreshCallback(refreshControl: UIRefreshControl) {
        populateTweets(refreshControl)
    }
    
    func populateTweets(refreshControl: UIRefreshControl? = nil) {
        if (self.mentions == true) {
            populateMentionsTweets()
        } else {
            populateHomeTweets()
        }
    }
    
    func populateHomeTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
        }
    }
    
    func populateMentionsTweets(refreshControl: UIRefreshControl? = nil) {
        TwitterClient.sharedInstance.mentionsTimelineWithCompletion(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "ViewTweet":
                var indexPath: NSIndexPath? = nil
                if let cell = sender as? TweetCell {
                    indexPath = tableView.indexPathForCell(cell)
                    cell.selectionStyle = .Blue
                    let tweet = tweets![indexPath!.row]
                    let detailViewController = segue.destinationViewController as! DetailViewController
                    self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
                    detailViewController.tweet = tweet
                }
            default:
                return
        }
    }
}

extension TweetsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        if let tweets = tweets {
            let tweet = tweets[indexPath.row]
            cell.nameLabel.text = (tweet.user?.name)! as String
            cell.usernameLabel.text = "@\((tweet.user?.screenname)! as String)"
            cell.descriptionLabel.text = tweet.text! as String
            cell.retweetCountLabel.text = tweet.retweetCount == 0 ? "" : String(tweet.retweetCount)
            cell.favoriteCountLabel.text = tweet.favoriteCount == 0 ? "" : String(tweet.favoriteCount)
            cell.profileImage.af_setImageWithURL(NSURL(string: (tweet.user?.profileImageURL!)!)!)
            let date = tweet.createdAt! as NSDate
            cell.timeAgoLabel.text = date.timeAgoInWords()
            
            cell.replyButton.tag = indexPath.row
            cell.retweetButton.tag = indexPath.row
            cell.favoriteButton.tag = indexPath.row
        }
        
        return cell
    }
}