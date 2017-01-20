//
//  Notification.swift
//  Twitter
//
//  Created by Xie kesong on 1/19/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation

struct  AppNotification{
    static let tweetDidSendNotificationName = Notification.Name("TweetDidSendNotification")
    static let tweetDidSendTweetInfoKey = Notification.Name("Tweet")

    static let userProfileTappedNotificationName = Notification.Name("UserProfileTappedNotification")
    static let userProfileTappedUserKey = Notification.Name("User")

}
