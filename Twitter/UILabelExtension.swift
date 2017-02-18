//
//  UILabelExtension.swift
//  Twitter
//
//  Created by Xie kesong on 2/16/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    func setRichText(tweet: Tweet){
        let attributedTweetText = NSMutableAttributedString(string: tweet.text)
       
        //style mentions
        if let mentions = tweet.userMentions{
            for mention in mentions{
                let mentionString = "@" + mention.screen_name
                let range = (tweet.text as NSString).range(of: mentionString)
                attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: App.themeColor , range: range)

            }
        }
        
        //style links
        if let urls = tweet.embedURLs{
            for url in urls{
                if let urlString = url.urlString{
                    let range = (tweet.text as NSString).range(of: urlString)
                    attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: App.themeColor , range: range)
                }
            }
        }
        
        //style hashTag
        if let tags = tweet.hashTags{
            for tag in tags{
                let hashTagText = "#" + tag.text
                let range = (tweet.text as NSString).range(of: hashTagText)
                attributedTweetText.addAttribute(NSForegroundColorAttributeName, value: App.themeColor , range: range)
            }
        }
        
        
        
        
        self.attributedText = attributedTweetText
    }
}
