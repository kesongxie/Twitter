//
//  Global.swift
//  Twitter
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import Foundation
import UIKit
class App{
    static let mainStoryboadName = "Main"
    static let grayColor = UIColor(red: 101 / 255.0, green: 119 / 255.0, blue: 134 / 255.0, alpha: 1)
    static let themeColor = UIColor(red: 23 / 255.0, green: 131 / 255.0, blue: 198 / 255.0, alpha: 1)
    static let bannerAspectRatio: CGFloat = 3.0
    
    static let delegate = (UIApplication.shared.delegate as? AppDelegate)
    static let mainStoryBoard = UIStoryboard(name: App.mainStoryboadName, bundle: nil)

    class func postStatusBarShouldUpdateNotification(style : UIStatusBarStyle){
        let userInfo = [AppNotification.statusBarStyleKey: style]
        let notification = Notification(name: AppNotification.statusBarShouldUpdateNotificationName, object: self, userInfo: userInfo)
        NotificationCenter.default.post(notification)
    }
    struct Style{
        static let userProfileAvatorCornerRadius: CGFloat = 4.0
    }
}

