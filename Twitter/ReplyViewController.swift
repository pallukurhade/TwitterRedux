//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Pallavi Kurhade on 10/30/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class ReplyViewController: UIViewController {

    
    var tweet:Tweet?
    var replyButton:UIBarButtonItem!
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var replyingToLabel: UILabel!
    @IBOutlet weak var replyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius = 3
        userImage.clipsToBounds = true
        
        let userImageURL = (User.currentUser?.profileUrl)! as URL
        userImage.setImageWith(userImageURL, placeholderImage: nil)
        
        replyingToLabel.text = "Replying to " + tweet!.userName!
      
        replyButton = UIBarButtonItem(title: "Reply", style: UIBarButtonItemStyle.plain, target: self, action: #selector(sendReply))
        replyButton.isEnabled = false
        
        let keyboardToolbar = UIToolbar(frame: CGRect(x:0,y:0,width:200,height:40))
        keyboardToolbar.barStyle = UIBarStyle.default
        keyboardToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            replyButton]
        keyboardToolbar.sizeToFit()
        replyTextField.inputAccessoryView = keyboardToolbar

        
        //delay to show keyboard
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(openKeyBoard), userInfo: nil, repeats: false)
    }
    
    @IBAction func onEditingChanged(_ sender: AnyObject) {
        if replyTextField.text != "" {
            replyButton.isEnabled = true
        }
        else {
            replyButton.isEnabled = false
        }
    }
    
    func sendReply() {
        if replyTextField.text != "" {
            let tweeterUserName = tweet?.userScreenName
            let replyString = "@" + tweeterUserName! + " " + replyTextField.text! as String

            TwitterClient.sharedInstance?.sendReplyTweet(targetId: (tweet?.tweetId)!, statusString: replyString, success: {() -> ()  in
                    self.exitThisView()
                }, failure: {(error: Error) -> () in
                    self.exitThisView()
                    
                    //TODO: show alert window
                    print("Error: \(error.localizedDescription)")
            })
        }
    }
    
    func openKeyBoard() {
        replyTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onExitButton(_ sender: AnyObject) {
        exitThisView()
    }

    func exitThisView() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
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
