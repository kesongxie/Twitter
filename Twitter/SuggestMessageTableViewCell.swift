//
//  SuggestMessageTableViewCell.swift
//  Twitter
//
//  Created by Xie kesong on 2/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class SuggestMessageTableViewCell: UITableViewCell {
    var user: User!{
        didSet{
            self.profileImageView.image = nil
            if let imageURL = self.user.profileImageURL{
                self.profileImageView?.setImageWith(imageURL)
            }
            self.nameLabel?.text = self.user.name
            self.screenNameLabel?.text = "@" + self.user.screen_name
        }
    }
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = App.Style.userProfileAvatorCornerRadius
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
