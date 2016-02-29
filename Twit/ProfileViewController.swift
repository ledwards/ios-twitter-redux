//
//  ProfileViewController.swift
//  Twit
//
//  Created by Lee Edwards on 2/26/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            nameLabel.text = user.name!
            usernameLabel.text = "@\(user.screenname!)"
            profileImageView.af_setImageWithURL(NSURL(string: user.profileImageURL!)!)
            headerImageView.af_setImageWithURL(NSURL(string: user.headerImageURL!)!)
            tweetsCountLabel.text = String(user.tweetsCount!)
            followingCountLabel.text = String(user.followingCount!)
            followerCountLabel.text = String(user.followerCount!)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
