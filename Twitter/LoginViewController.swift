//
//  LoginViewController.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 10/29/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onLoginButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.login(success: {() -> ()  in
            self.performSegue(withIdentifier: "toHamburgerViewSegue", sender: nil)
        }, failure: {(error: Error) -> () in
            print("Login Error: \(error.localizedDescription)")
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHamburgerViewSegue" {
            let hamburgerViewController = segue.destination as! HamburgerViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            menuViewController.hamburgerViewController = hamburgerViewController
            hamburgerViewController.menuViewController = menuViewController
        }
    }
}
