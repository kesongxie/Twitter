//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let charMaxLimit = 150

class ComposeViewController: UIViewController {

    @IBOutlet weak var currentUserProfileImageView: UIImageView!{
        didSet{
            self.currentUserProfileImageView.becomeRoundedProfilePicture()
        }
    }
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var currentUserScreenNameLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var closeBtn: UIBarButtonItem!{
        didSet{
            self.closeBtn.tintColor = App.themeColor
        }
    }
    @IBAction func closeBtnTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tweetBtn: UIButton!{
        didSet{
            self.tweetBtn.layer.cornerRadius = 6.0
        }
    }
    
    @IBOutlet weak var charRemainingCountLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func tweetBtnTapped(_ sender: UIButton) {
        if let text = self.textView.text{
            TwitterClient.sendTweet(text: text, callBack: { (tweet, error) in
                DispatchQueue.main.async {
                    self.view.endEditing(true)
                    if let tweet = tweet{
                        let userInfo = [AppNotification.tweetDidSendTweetInfoKey: tweet]
                        let didTweetNotification = Notification(name: AppNotification.tweetDidSendNotificationName, object: self, userInfo: userInfo)
                        NotificationCenter.default.post(didTweetNotification)
                    }
                    self.dismiss(animated: true, completion: nil)

                }
            })
        }
    }
    
    @IBOutlet weak var limitCounter: UILabel!
    var remainingCharCount: Int = charMaxLimit
    var footerViewInitialOriginY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        self.scrollView.alwaysBounceVertical = true
        if let currentLoggedInUser = (UIApplication.shared.delegate as? AppDelegate)?.currentUser{
            if let url = currentLoggedInUser.profileImageURL{
                self.currentUserProfileImageView.setImageWith(url)
            }
            self.currentUserNameLabel.text = currentLoggedInUser.name
            self.currentUserScreenNameLabel.text = "@\(currentLoggedInUser.screen_name!)"
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: Notification.Name("UIKeyboardDidShowNotification"), object: nil)
        
        self.updatePlaceHodlerUI()
        self.textView.becomeFirstResponder()
        self.updateTweetBtnState()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.footerViewInitialOriginY = self.footerView.frame.origin.y
    }

    func updatePlaceHodlerUI(){
        self.placeHolderLabel.isHidden = !self.textView.text.isEmpty
    }
    
    func updateTweetBtnState(){
        if self.textView.text.isEmpty{
            self.tweetBtn.isEnabled = false
            self.tweetBtn.alpha = 0.6
        }else{
            self.tweetBtn.isEnabled = true
            self.tweetBtn.alpha = 1
        }
    }
    
    func updateLimitCounter(){
        self.remainingCharCount = charMaxLimit - self.textView.text.characters.count
        self.limitCounter.text = String(remainingCharCount)
    }
    
    func updateCounterColorState(){
        if self.remainingCharCount <= 10{
            self.limitCounter.textColor = UIColor(red: 145 / 255.0, green: 15 / 255.0, blue: 15 / 255.0, alpha: 1.0)
        }else{
            self.limitCounter.textColor = App.grayColor
        }
    }

    
    func keyboardDidShow(notification: Notification){
        if let keyboardRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            let keyboardHeight = keyboardRect.height
            UIView.animate(withDuration: 0.3, animations: {
                self.footerView.frame.origin.y = self.footerViewInitialOriginY - keyboardHeight
                self.footerBottomConstraint.constant = keyboardHeight
            })
        }
    }
}

extension ComposeViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.updateCounterColorState()
        self.updateTweetBtnState()
        self.updateLimitCounter()
        self.updatePlaceHodlerUI()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.characters.count == charMaxLimit && !text.isEmpty{
            return false
        }
        return true
    }
}
