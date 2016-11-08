//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 11/5/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit



class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeftMarginConstraint: NSLayoutConstraint!
    
    var currentTimelineMode:TimelineMode = .Home
  
    var originalContentViewLeftMarginConstraint:CGFloat!
    
    var menuViewController: UIViewController! {
        didSet(oldMenuViewController) {
            view.layoutIfNeeded()
            if oldMenuViewController != nil {
                oldMenuViewController.willMove(toParentViewController: nil)
                oldMenuViewController.view.removeFromSuperview()
                oldMenuViewController.didMove(toParentViewController: nil)
            }
            
            menuViewController.willMove(toParentViewController: nil)
            menuViewController.view.removeFromSuperview()
            menuViewController.didMove(toParentViewController: nil)
            
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tweetsNavigationController = storyBoard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        contentViewController = tweetsNavigationController
        contentView.addSubview(contentViewController.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTimelineMode(mode: String) {
        switch mode {
            case "Home":
                currentTimelineMode = .Home
            case "Profile":
                currentTimelineMode = .Profile
            case "Mentions":
                currentTimelineMode = .Mentions
            default:
                currentTimelineMode = .Home
        }

        // update tweetsViewController
        let tweetsViewVontroller = (contentViewController as! UINavigationController).topViewController as! TweetsViewController
        tweetsViewVontroller.currentTimelineMode = self.currentTimelineMode

        // close menu view
        UIView.animate(withDuration: 0.3, animations: {
            self.contentViewLeftMarginConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)

        if sender.state == UIGestureRecognizerState.began {
            originalContentViewLeftMarginConstraint = contentViewLeftMarginConstraint.constant
        }
        else if sender.state == UIGestureRecognizerState.changed {
            if originalContentViewLeftMarginConstraint + translation.x > 0 {
                contentViewLeftMarginConstraint.constant = originalContentViewLeftMarginConstraint + translation.x
            }
        }
        else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.3, animations: {
                if velocity.x > 0 {
                    self.contentViewLeftMarginConstraint.constant = self.view.frame.size.width - 50
                }
                else {
                    self.contentViewLeftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
            })
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
