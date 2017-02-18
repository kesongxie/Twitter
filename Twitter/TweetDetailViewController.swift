//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            self.userImageView.layer.cornerRadius = 4.0
            self.userImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favorCountLabel: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var favorBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.alwaysBounceVertical = true
        }
    }
    @IBAction func barBtnTapped(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var mediaPhotoImageView: UIImageView!{
        didSet{
            self.mediaPhotoImageView.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
    
    @IBAction func replyBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: App.mainStoryboadName, bundle: nil)
        if let replyNVC = storyboard.instantiateViewController(withIdentifier: StorybordIdentifier.ReplyNavigationViewControllerIden) as? ReplyNavigationViewController{
            if let replyVC = replyNVC.viewControllers.first as? ReplyViewController{
                replyVC.tweetToReply = self.tweet
                self.present(replyNVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func retweetBtnTapped(_ sender: UIButton) {
        var retweetToggleOption: TwitterClient.RetweetToggleOption
        if self.tweet.retweeted{
            retweetToggleOption = .destroy
        }else{
            retweetToggleOption = .create
        }
        TwitterClient.toggleRetweet(tweet: self.tweet, option: retweetToggleOption) { (tweet, error) in
            if tweet != nil{
                self.tweet = tweet
                self.retweetCountLabel.text = String(tweet!.retweetCount)
                self.updateRetweetIconUI()
            }
        }
    }
    
    @IBAction func favorBtnTapped(_ sender: UIButton) {
        var favorToggleOption: TwitterClient.FavorToggleOption
        if self.tweet.favored{
            favorToggleOption = .destroy
        }else{
            favorToggleOption = .create
        }
        TwitterClient.toggleFavorTweet(tweet: self.tweet, option: favorToggleOption) { (tweet, error) in
            if tweet != nil{
                self.tweet = tweet
                self.favorCountLabel.text = String(tweet!.favoriteCount)
                self.updateFavorIconUI()
            }
        }
    }
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        if self.tweet != nil{
            self.updateUI()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        App.postStatusBarShouldUpdateNotification(style: .default)
        self.navigationController?.isNavigationBarHidden = false;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(){
        if let userProfileURL = self.tweet.user.profileImageURL{
            self.userImageView.setImageWith(userProfileURL)
        }
        self.nameLabel.text = tweet.user.name
        self.screenNameLabel.text = "@" + self.tweet.user.screen_name
        self.tweetTextLabel.setRichText(tweet: self.tweet)
        self.createdAtLabel.text = self.tweet.createdAt
        self.retweetCountLabel.text = String(self.tweet.retweetCount)
        self.favorCountLabel.text = String(self.tweet.favoriteCount)
        
        self.updateFavorIconUI()
        self.updateRetweetIconUI()
        
        self.mediaPhotoImageView.image = nil
        if let photo = self.tweet.photos?.first{
            self.mediaHeightConstraint.constant = self.mediaPhotoImageView.frame.size.width * photo.size.height / photo.size.width
            self.mediaPhotoImageView.setImageWith(photo.photoURL)
        }else{
            self.mediaHeightConstraint.constant = 0
        }
    }
    
    
    func updateFavorIconUI(){
        var imageName = ""
        if self.tweet.favored{
            imageName = "favor-icon-red"
        }else{
            imageName = "favor-icon"
        }
        let image = UIImage(named: imageName)
        self.favorBtn.setImage(image, for: .normal)
    }
    
    func updateRetweetIconUI(){
        var imageName = ""
        if self.tweet.retweeted{
            imageName = "retweet-icon-green"
        }else{
            imageName = "retweet-icon"
        }
        let image = UIImage(named: imageName)
        self.retweetBtn.setImage(image, for: .normal)
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
