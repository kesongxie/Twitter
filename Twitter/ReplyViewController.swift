//
//  CommentViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    var tweetToReply: Tweet?
    @IBOutlet weak var currentUserProfileImageView: UIImageView!{
        didSet{
            self.currentUserProfileImageView.becomeRoundedProfilePicture()
        }
    }
    @IBOutlet weak var currentUserNameLabel: UILabel!
    @IBOutlet weak var currentUserScreenNameLabel: UILabel!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func closeBtnTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self
        if let currentLoggedInUser = (UIApplication.shared.delegate as? AppDelegate)?.currentUser{
            if let url = currentLoggedInUser.profileImageURL{
                self.currentUserProfileImageView.setImageWith(url)
            }
            self.currentUserNameLabel.text = currentLoggedInUser.name
            self.currentUserScreenNameLabel.text = "@\(currentLoggedInUser.screen_name!)"
        }
        self.updatePlaceHodlerUI()
        self.textView.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePlaceHodlerUI(){
        self.placeHolderLabel.isHidden = !self.textView.text.isEmpty
    }
}

extension ReplyViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        self.updatePlaceHodlerUI()
    }
}
