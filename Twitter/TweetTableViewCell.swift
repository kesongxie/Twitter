//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit


protocol TweetTableViewCellDelegate: class  {
    func mediaImageViewTapped(cell: TweetTableViewCell, image: UIImage?,  tweet: Tweet)
    func profileImageViewTapped(cell: TweetTableViewCell, tweet: Tweet)

}

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!{
        didSet{
            self.userImageView.layer.cornerRadius = App.Style.userProfileAvatorCornerRadius
            self.userImageView.clipsToBounds = true
            self.userImageView.isUserInteractionEnabled = true
            //tap for userImageView
            let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(userProfileTapped(_:)))
            self.userImageView.addGestureRecognizer(userProfileTap)

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
    
    @IBOutlet weak var retweetStackView: UIStackView!{
        didSet{
            //tap for retweet
            let retweetTap = UITapGestureRecognizer(target: self, action: #selector(retweetStackViewTapped(_:)))
            self.retweetStackView.addGestureRecognizer(retweetTap)
        }
    }
    
    @IBOutlet weak var favorStackView: UIStackView!{
        didSet{
            //tap for favor
            let favorTap = UITapGestureRecognizer(target: self, action: #selector(favorStackViewTapped(_:)))
            self.favorStackView.addGestureRecognizer(favorTap)
        }
    }
    
    @IBOutlet weak var mediaPhotoImageView: UIImageView!{
        didSet{
            self.mediaPhotoImageView.clipsToBounds = true
            self.mediaPhotoImageView.layer.cornerRadius = 4.0
            self.mediaPhotoImageView.isUserInteractionEnabled = true
            let mediaTap = UITapGestureRecognizer(target: self, action: #selector(mediaTaped(_:)))
            self.mediaPhotoImageView.addGestureRecognizer(mediaTap)

        }
    }
    
    @IBOutlet weak var mediaHeightConstraint: NSLayoutConstraint!
    
    var tweet: Tweet!{
        didSet{
            self.userImageView.image = nil
            if let userProfileURL = self.tweet.user.profileImageURL{
                self.userImageView.loadImageWithURL(userProfileURL, withFadeIn: true)
            }
            self.nameLabel.text = tweet.user.name
            self.screenNameLabel.text = "@" + self.tweet.user.screen_name
            self.tweetTextLabel.setRichText(tweet: self.tweet)
            self.createdAtLabel.text = self.tweet.createdAt
            self.retweetCountLabel.text = self.tweet.retweetCount == 0 ? "" : self.tweet.retweetCountString
            self.favorCountLabel.text =  self.tweet.favoriteCount == 0 ? "" : self.tweet.favoriteCountString
            
            
            self.updateFavorIconUI()
            self.updateRetweetIconUI()
            
            self.mediaPhotoImageView.image = nil
            if let photo = self.tweet.photos?.first{
                self.mediaHeightConstraint.constant = self.mediaPhotoImageView.frame.size.width * photo.size.height / photo.size.width
                self.mediaPhotoImageView.loadImageWithURL(photo.photoURL, withFadeIn: true)
            }else{
                self.mediaHeightConstraint.constant = 0
            }
        }
    }
    
    weak var delegate: TweetTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func favorStackViewTapped(_ gesture: UITapGestureRecognizer){
        var favorToggleOption: TwitterClient.FavorToggleOption
        if self.tweet.favored{
            favorToggleOption = .destroy
        }else{
            favorToggleOption = .create
        }
        TwitterClient.toggleFavorTweet(tweet: self.tweet, option: favorToggleOption) { (tweet, error) in
            if tweet != nil{
                self.tweet = tweet
                self.favorCountLabel.text =  self.tweet.favoriteCount == 0 ? "" : self.tweet.favoriteCountString
                self.updateFavorIconUI()
            }
        }
    }
    
    func retweetStackViewTapped(_ gesture: UITapGestureRecognizer){
        var retweetToggleOption: TwitterClient.RetweetToggleOption
        if self.tweet.retweeted{
            retweetToggleOption = .destroy
        }else{
            retweetToggleOption = .create
        }
        TwitterClient.toggleRetweet(tweet: self.tweet, option: retweetToggleOption) { (tweet, error) in
            if tweet != nil{
                self.tweet = tweet
                self.retweetCountLabel.text = self.tweet.retweetCount == 0 ? "" : self.tweet.retweetCountString
                self.updateRetweetIconUI()
            }
        }
    }
    
    func mediaTaped(_ gesture: UITapGestureRecognizer){
        if let delegate = delegate{
            delegate.mediaImageViewTapped(cell: self, image: self.mediaPhotoImageView.image, tweet: self.tweet)
        }
    }
    
    func userProfileTapped(_ gesture: UITapGestureRecognizer){
        if let delegate = delegate{
            delegate.profileImageViewTapped(cell: self, tweet: self.tweet)
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
