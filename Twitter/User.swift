//
//  User.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation

fileprivate let currentUserKey = "CurrentUser"
fileprivate let currentUserTimeLineKey = "CurrentUserTimeLine"

class User{
    let userDict: [String: Any]!
    let id: UInt?
    let name: String!
    let screen_name: String!
    let description: String?
    let profile_banner_url_string: String?
    let profile_image_url_string: String?
    
    var profileImageURL: URL?{
        guard var urlString = self.profile_image_url_string else{
            return nil
        }
        urlString = urlString.replacingOccurrences(of: "_normal", with: "")
        return URL(string: urlString)
    }
    
    var profileBannerURL: URL?{
        guard var urlString = self.profile_banner_url_string else{
            return nil
        }
        urlString = urlString + "/600x200"
        return URL(string: urlString)
    }
    
    var lowesLoadedtTimeLineId: Int64{
        get{
            
            if let timeline = self.timeline{
                let idList: [Int64] = timeline.map({ (tweet) -> Int64 in
                    return tweet.id
                })
                return idList.min()! - 1
            }
            return Int64.max
        }
    }
    
    var timeline: [Tweet]?{
        didSet{
            self.syncCurrentUserData()
        }
    }
    
    var followingCount: UInt32{
        return self.userDict["friends_count"] as! UInt32
    }
    
    var followingCountString: String{
        return  Ultility.stringifyCount(count: followingCount)
    }
    
    var followerCount: UInt32{
        return self.userDict["followers_count"] as! UInt32
    }
    
    
    var followerCountString: String{
        return  Ultility.stringifyCount(count: followerCount)
    }
    
    var location: String?{
        return self.userDict["location"] as? String
    }
    
    var entitiesDict: [String: Any]?{
        return self.userDict?["entities"] as? [String: Any]
    }
    var embedURLs: EmbedURL?{
        guard let entitiesDict = self.entitiesDict else{
            return nil
        }
        guard let urls = entitiesDict["url"] as? [String: Any] else{
            return nil
        }
        guard let urlDict = (urls["urls"] as? [[String: Any]])?.first else{
            return nil
        }
        return EmbedURL(urlDict: urlDict)
    }

    
    init(userDict: [String: Any]) {
        self.userDict = userDict
        self.id = userDict["id"] as? UInt
        self.name = userDict["name"] as? String
        self.screen_name = userDict["screen_name"] as? String
        self.description = userDict["description"] as? String
        self.profile_banner_url_string = userDict["profile_banner_url"] as? String
        self.profile_image_url_string = userDict["profile_image_url"] as? String
    }
    
    func saveCurrentUserData(){
        do{
            let userData = try JSONSerialization.data(withJSONObject: userDict, options: [])
            UserDefaults.standard.set(userData, forKey: currentUserKey)
            if let timelineTweets = self.timeline{
                let timelineData = try? timelineTweets.map({ (tweet) -> Data in
                    return try JSONSerialization.data(withJSONObject: tweet.tweetDict, options: [])
                })
                if let timeLineData = timelineData{
                    UserDefaults.standard.set(timeLineData, forKey: currentUserTimeLineKey)
                }
            }
        }catch{
            print("can't serialize")
        }
    }
    
    func syncCurrentUserData(){
        self.saveCurrentUserData()
    }
    
    
    class func getCurrentUser() -> User?{
        if let userData = UserDefaults.standard.object(forKey: currentUserKey) as? Data{
            do{
                let userJson = try JSONSerialization.jsonObject(with: userData, options: [])
                if let userDict = userJson as? [String: Any]{
                    let user = User(userDict: userDict)
                    if let timeLineData = UserDefaults.standard.object(forKey: currentUserTimeLineKey) as? [Data]{
                        user.timeline = try? timeLineData.map({ (tweetData) -> Tweet in
                            let tweetJson = try JSONSerialization.jsonObject(with: tweetData, options: [])
                            let tweetDict = tweetJson as! [String: Any]
                                return Tweet(tweetDict: tweetDict)
                            })
                    }
                    return user
                }
            }catch{
                return nil
            }
        }
        return nil
    }
    
    class func deAuthenticate(){
        TwitterClient.shareInstance?.deauthorize()
        UserDefaults.standard.removeObject(forKey: currentUserKey)
        App.delegate?.currentUser = nil
        let notification = Notification(name: TwitterClient.TwitterClientDidDeAuthenticateNotificationName, object: self, userInfo: nil)
        NotificationCenter.default.post(notification)
    }

}













