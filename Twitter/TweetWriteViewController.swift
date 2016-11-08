//
//  TweetWriteViewController.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 10/31/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

@objc protocol TweetWriteViewControllerrDelegate {
    @objc optional func tweetWriteViewController(tweetWriteViewController: TweetWriteViewController, addedTweet: AnyObject)
}

class TweetWriteViewController: UIViewController {

    var tweetButton:UIBarButtonItem!

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tweetBodyTextField: UITextField!
    
    weak var delegate: TweetWriteViewControllerrDelegate?
    
    var returnedData:AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImage.layer.cornerRadius = 3
        userImage.clipsToBounds = true
        
        let userImageURL = (User.currentUser?.profileUrl)! as URL
        userImage.setImageWith(userImageURL, placeholderImage: nil)
        
        tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendTweet))
        tweetButton.isEnabled = false
        
        let keyboardToolbar = UIToolbar(frame: CGRect(x:0,y:0,width:200,height:40))
        keyboardToolbar.barStyle = UIBarStyle.default
        keyboardToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            tweetButton]
        keyboardToolbar.sizeToFit()
        tweetBodyTextField.inputAccessoryView = keyboardToolbar
        
        //delay to show keyboard
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(openKeyBoard), userInfo: nil, repeats: false)
    }

    @IBAction func onExitButton(_ sender: AnyObject) {
        exitThisView()
    }
    
    func openKeyBoard() {
        tweetBodyTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditingChanged(_ sender: AnyObject) {
        if tweetBodyTextField.text != "" {
            tweetButton.isEnabled = true
        }
        else {
            tweetButton.isEnabled = false
        }
    }
    
    func exitThisView() {
        self.view.endEditing(true)
        delegate?.tweetWriteViewController?(tweetWriteViewController: self, addedTweet: returnedData!)
        
        self.dismiss(animated: true, completion: nil)
    }

    func sendTweet() {
        if tweetBodyTextField.text != "" {
            let tweetString = tweetBodyTextField.text! as String
            
            TwitterClient.sharedInstance?.sendTweet(tweetString: tweetString, success: {() -> ()  in
                    self.exitThisView()
                }, failure: {(error: Error) -> () in
                    self.exitThisView()
                    
                    //TODO: show alert window
                    print("Error: \(error.localizedDescription)")
            })
        }
    }
}
