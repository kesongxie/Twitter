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
    
    var tweet: Tweet!{
        didSet{
            if let userProfileURL = URL(string: self.tweet.user.profile_image_url!){
                self.userImageView.setImageWith(userProfileURL)
            }
            self.nameLabel.text = tweet.user.name
            self.screenNameLabel.text = "@" + self.tweet.user.screen_name
            self.tweetTextLabel.text = self.tweet.text
            self.createdAtLabel.text = self.tweet.createdAt
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

}
