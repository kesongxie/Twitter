//
//  SectionHeaderTableViewCell.swift
//  Twitter
//
//  Created by Xie kesong on 2/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class SectionHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var inReplyToLabel: UILabel!{
        didSet{
            guard let currentUser = App.delegate?.currentUser else{
                return
            }
            
            self.inReplyToLabel.text = "In reply to " + currentUser.name
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
