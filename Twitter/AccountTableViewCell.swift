//
//  AccountTableViewCell.swift
//  Twitter
//
//  Created by Xie kesong on 1/19/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = 4.0
            self.profileImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var user: User!{
        didSet{
            if self.user != nil{
                self.profileImageView.setImageWith(user.profileImageURL!)
                self.nameLabel.text = user.name
                self.screenNameLabel.text = user.screen_name
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

}
