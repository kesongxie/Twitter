//
//  Tweet.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation

class Tweet{
    let tweetDict: [String: Any]!
    var id: UInt{
        return tweetDict["id"] as! UInt
    }
    
    var text: String{
        return tweetDict["text"] as? String ?? ""
    }
    
    var createdAt: String{
        return  Ultility.agoString(from: (tweetDict["created_at"] as? String) ?? "")
    }
    
    var favoriteCount: UInt{
        return tweetDict["favorite_count"] as! UInt
    }
 
    var retweetCount: UInt{
        return tweetDict["retweet_count"] as! UInt
    }

    var favored: Bool{
        return tweetDict["favorited"] as! Bool
    }
    
    var retweeted: Bool{
        return tweetDict["retweeted"] as! Bool
    }

    var user: User{
        return User(userDict: tweetDict["user"] as! [String: Any])
    }
    
    init(tweetDict: [String: Any]) {
        self.tweetDict = tweetDict
    }
}
