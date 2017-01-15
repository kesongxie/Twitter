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
    let text: String!
    let createdAt: String!
    let user: User!
    init(tweetDict: [String: Any]) {
        self.tweetDict = tweetDict
        self.text = tweetDict["text"] as? String ?? ""
        self.createdAt = Ultility.agoString(from: (tweetDict["created_at"] as? String) ?? "")
        self.user = User(userDict: tweetDict["user"] as! [String: Any])
    }
}
