//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit


class TweetTableViewCell: UITableViewCell {
    
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
    
    
    @IBOutlet weak var replyIconImageView: UIImageView!
    
    @IBOutlet weak var retweetIconImageView: UIImageView!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favorIconImageView: UIImageView!
    
    @IBOutlet weak var favorCountLabel: UILabel!
    
    @IBOutlet weak var retweetStackView: UIStackView!
    
    @IBOutlet weak var favorStackView: UIStackView!
    
    @IBOutlet weak var mediaPhotoImageView: UIImageView!{
        didSet{
            self.mediaPhotoImageView.layer.cornerRadius = 4.0
        }
    }
    
    @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
    
    var tweet: Tweet!{
        didSet{
            if let userProfileURL = self.tweet.user.profileImageURL{
                self.userImageView.setImageWith(userProfileURL)
            }
            
            self.nameLabel.text = tweet.user.name
            self.screenNameLabel.text = "@" + self.tweet.user.screen_name
            self.tweetTextLabel.text = self.tweet.text
            self.createdAtLabel.text = self.tweet.createdAt
            self.retweetCountLabel.text = String(self.tweet.retweetCount)
            self.favorCountLabel.text = String(self.tweet.favoriteCount)
            
            //tap for favor
            let favorTap = UITapGestureRecognizer(target: self, action: #selector(favorStackViewTapped(gesture:)))
            self.favorStackView.addGestureRecognizer(favorTap)
            
            //tap for retweet
            let retweetTap = UITapGestureRecognizer(target: self, action: #selector(retweetStackViewTapped(gesture:)))
            self.retweetStackView.addGestureRecognizer(retweetTap)
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func favorStackViewTapped(gesture: UITapGestureRecognizer){
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
    
    func retweetStackViewTapped(gesture: UITapGestureRecognizer){
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

    
    func updateFavorIconUI(){
        if self.tweet.favored{
            self.favorIconImageView.image = UIImage(named: "favor-icon-red")
        }else{
            self.favorIconImageView.image = UIImage(named: "favor-icon")
        }
    }
    
    func updateRetweetIconUI(){
        if self.tweet.retweeted{
            self.retweetIconImageView.image = UIImage(named: "retweet-icon-green")
        }else{
            self.retweetIconImageView.image = UIImage(named: "retweet-icon")
        }
        
    }
    

    

}
