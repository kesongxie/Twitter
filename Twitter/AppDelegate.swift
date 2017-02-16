//
//  AppDelegate.swift
//  Twitter
//
//  Created by Xie kesong on 1/14/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    static let FinishedLogInNotificationName = Notification.Name("FinishedLogInNotification")
    static let FinishedLogInUserInfoKey = "FinishedLogInTweetsInfo"
    static let FailedToLogInNotificationName = Notification.Name("FailedToLogInNotificatio")

    static let CurrentUserAvailableNotificationName = Notification.Name("CurrentUserAvailableNotification")
    static let CurrentUserAvailableUserInfoKey = "CurrentUserAvailableUserInfo"


    var window: UIWindow?
    var currentUser: User?{
        didSet{
            if accounts.isEmpty{
                self.accounts.append(self.currentUser!)
            }else{
                if let index = self.accounts.index(where: {$0.screen_name == self.currentUser!.screen_name}){
                    self.accounts.remove(at: index)
                    self.accounts.insert(self.currentUser!, at: 0)
                }
            }
        }
    }
    var accounts = [User]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let user = User.getCurrentUser(){
            self.currentUser = user
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //response to the url open and bring the user back to our app duraing the oAuth process
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.fetchAccessTokenWithURL(
            url: url,
            success: {(credential: BDBOAuth1Credential?) in
                //now the user logged in
                TwitterClient.getUserProfile(callBack: { (user, error) in
                    if let user = user{
                        self.currentUser = user
                        self.currentUser!.saveCurrentUserData()
                        TwitterClient.getHomeTimeLine(callBack: {(tweets, error) in
                            self.currentUser?.timeline = tweets
                            let user = [AppDelegate.FinishedLogInUserInfoKey: self.currentUser]
                            let finishedLogInNotification = Notification(name: AppDelegate.FinishedLogInNotificationName, object: self, userInfo: user)
                            NotificationCenter.default.post(finishedLogInNotification)
                        })
                    }
                })
            },
            failure:{(error: Error?) in
                let failedToLogInNotification = Notification(name: AppDelegate.FailedToLogInNotificationName, object: self, userInfo: nil)
                NotificationCenter.default.post(failedToLogInNotification)
                if error != nil{
                    print(error!.localizedDescription)
                }
          })
        return true
    }
    
    
    

}

