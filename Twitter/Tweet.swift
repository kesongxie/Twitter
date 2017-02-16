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
    var id: Int64{
        return tweetDict["id"] as! Int64
    }
    
    var text: String{
        return tweetDict["text"] as? String ?? ""
    }
    
    var createdAt: String{
        var timeStamp: String?
        if let retweetStatus = tweetDict["retweeted_status"] as? [String: Any]{
            timeStamp = retweetStatus["created_at"] as? String
        }else{
            timeStamp = tweetDict["created_at"] as? String
        }
        return  Ultility.agoString(from:timeStamp ?? "")
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
    
    var photos: [TweetPhoto]?{
        guard  let entitiesDict = tweetDict["entities"] as? [String: Any] else{
            return nil
        }
        
        guard let mediaDictArray = entitiesDict["media"] as? [[String: Any]] else{
            return nil
        }
        
        return mediaDictArray.map { (mediaDict) -> TweetPhoto in
            TweetPhoto(photoDict: mediaDict)
        }
    }

    var user: User{
        return User(userDict: tweetDict["user"] as! [String: Any])
    }
      
    init(tweetDict: [String: Any]) {
        self.tweetDict = tweetDict
    }
}
