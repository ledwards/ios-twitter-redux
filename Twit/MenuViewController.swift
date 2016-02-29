//
//  MenuViewController.swift
//  Twit
//
//  Created by Lee Edwards on 2/26/16.
//  Copyright © 2016 Lee Edwards. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var viewControllers: [UIViewController] = []
    let titles = ["Timeline", "Mentions", "Profile"]
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tvc = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
        let mvc = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
        let pvc = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        viewControllers.append(tvc)
        viewControllers.append(mvc)
        viewControllers.append(pvc)
//        hamburgerViewController.contentViewController = viewControllers[0]
        
        tableView.estimatedRowHeight = 32.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(red: CGFloat(85.0/255.0), green: CGFloat(172.0/255.0), blue: CGFloat(238.0/255.0), alpha: CGFloat(1.0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MenuViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
}
