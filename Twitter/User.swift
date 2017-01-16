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
    let profile_banner_url: String?
    let profile_image_url: String?
    
    var lowesLoadedtTimeLineId: UInt{
        get{
            
            if let timeline = self.timeline{
                let idList: [UInt] = timeline.map({ (tweet) -> UInt in
                    return tweet.id
                })
                return idList.min()!
            }
            return UInt.max
        }
    }
    
    var timeline: [Tweet]?{
        didSet{
            self.syncCurrentUserData()
        }
    }
    
    init(userDict: [String: Any]) {
        self.userDict = userDict
        self.id = userDict["id"] as? UInt
        self.name = userDict["name"] as? String
        self.screen_name = userDict["screen_name"] as? String
        self.description = userDict["description"] as? String
        self.profile_banner_url = userDict["profile_banner_url"] as? String
        self.profile_image_url = userDict["profile_image_url"] as? String
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

}













