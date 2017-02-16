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
    
    func loadImageWithURL(_ url: URL, withFadeIn animated: Bool){
        let ulrRequest = URLRequest(url: url)
        self.setImageWith(ulrRequest, placeholderImage: nil, success: { (request, response, image) in
            self.image = image
            if response != nil && animated{
                //not from the cache
                self.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 1
                })
            }
        }, failure: nil)

    }
}

