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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        TwitterClient.sharedInstance.homeTimelineWithCompletion(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            print("loading timeline")
        }
        
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        print("logout button pressed")
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
            
            let date = tweet.createdAt! as NSDate
            cell.timeAgoLabel.text = date.timeAgoInWords()
            
            cell.profileImage.af_setImageWithURL(NSURL(string: (tweet.user?.profileImageURL!)!)!)
        }
        
        return cell
    }
}