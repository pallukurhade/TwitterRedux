//
//  MenuViewController.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 11/5/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    
    private var tweetsNavigationController:UIViewController!
    var hamburgerViewController: HamburgerViewController!
    var titles = ["Home", "Profile", "Mentions"]
 
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.dataSource = self
        menuTableView.delegate = self
        
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if indexPath.row == 0 {
            cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuProfileTableViewCell") as! MenuProfileTableViewCell

            let currentUser = User.currentUser
            (cell as! MenuProfileTableViewCell).userImage.setImageWith((currentUser?.profileUrl)!)
            (cell as! MenuProfileTableViewCell).userNameLabel.text = currentUser?.name
            (cell as! MenuProfileTableViewCell).userTagLineLabel.text = currentUser?.tagline
        }
        else {
            cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
            (cell as! MenuTableViewCell).menuTitleLabel.text = titles[indexPath.row - 1]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuTableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row > 0 {
            hamburgerViewController.setTimelineMode(mode: titles[indexPath.row - 1])
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
