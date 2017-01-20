//
//  UIImageViewExtension.swift
//  Twitter
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

extension UIImageView{
    func becomeRoundedProfilePicture(){
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
    }
}
