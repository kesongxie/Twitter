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
    
    var favoriteCount: UInt32{
        return tweetDict["favorite_count"] as! UInt32
    }
    
    var favoriteCountString: String{
        return  Ultility.stringifyCount(count: self.favoriteCount)
    }
 
    var retweetCount: UInt32{
        return tweetDict["retweet_count"] as! UInt32
    }
    
    
    var retweetCountString: String{
        return  Ultility.stringifyCount(count: self.retweetCount)
    }
    
    var favored: Bool{
        return self.tweetDict["favorited"] as! Bool
    }
    
    var retweeted: Bool{
        return self.tweetDict["retweeted"] as! Bool
    }
    
    var entitiesDict: [String: Any]?{
        return self.tweetDict["entities"] as? [String: Any]
    }
    
    var mediaArray: [[String: Any]]?{
        return self.entitiesDict?["media"] as? [[String: Any]]
    }
    
    
    var embedURLs: [EmbedURL]?{
        if let embedURLDicts = self.entitiesDict?["urls"] as? [[String: Any]]{
            return embedURLDicts.map({ (urlDict) -> EmbedURL in
                return EmbedURL(urlDict: urlDict)
            })
        }
        return nil
    }

    
    var userMentions: [UserMention]?{
        if let mentionsDicts = self.entitiesDict?["user_mentions"] as? [[String: Any]]{
            return mentionsDicts.map({ (mentionDict) -> UserMention in
                return UserMention(mentionDict: mentionDict)
            })
        }
        return nil
    }
    
    
    var hashTags: [HashTag]?{
        if let hashTags = self.entitiesDict?["hashtags"] as? [[String: Any]]{
            return hashTags.map({ (tagDict) -> HashTag in
                return HashTag(tagDict: tagDict)
            })
        }
        return nil
    }


    
    var photos: [TweetPhoto]?{
        guard let mediaDictArray = mediaArray else{
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
