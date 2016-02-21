//
//  ComposeTweetViewController.swift
//  Twit
//
//  Created by Lee Edwards on 2/20/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit
import AlamofireImage

class ComposeTweetViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var metaLabel: UILabel!
    
    var replyToID: Int?
    var replyToUsername: String?
    
    @IBAction func cancelPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func tweetPressed(sender: AnyObject) {
        let params: NSMutableDictionary = NSMutableDictionary(dictionary: ["status": textView.text])
        if let replyToID = replyToID {
            params.setValue(replyToID, forKey: "in_reply_to_status_id")
        }
        
        TwitterClient.sharedInstance.createTweetWithCompletion(params) {
            (tweet, error) -> () in
                if tweet != nil {
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    print(error?.description)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User.currentUser
        
        profileImage.af_setImageWithURL(NSURL(string: (user?.profileImageURL)!)!)
        nameLabel.text = user?.name
        usernameLabel.text = user?.screenname
        if let name = replyToUsername {
            metaLabel.text = "in reply to @\(name)"
            textView.text = "@\(name) "
        }
        
        self.textView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
