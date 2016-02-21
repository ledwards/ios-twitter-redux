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
    }
    
    @IBAction func favoritePressed(sender: AnyObject) {
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
