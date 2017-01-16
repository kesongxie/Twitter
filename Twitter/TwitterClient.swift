//
//  TwitterClient.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import BDBOAuth1Manager

class TwitterClient{
    enum FavorToggleOption{
        case create
        case destroy
    }
    
    enum RetweetToggleOption{
        case create
        case destroy
    }
    
    static let oAuthURLScheme = "twitter"
    static let oAuthURLHost = "oauth"
    static let oAuthBaseURL = "https://api.twitter.com"
    static let consumerKey = "CPTT9Mc1RC7f6WtmsOPVCBycG"
    static let consumerSecret = "4BdaMieYG9CcT9Bg3WrEG89QGZaDakJDDIaqxDnkWsPTjE5Jxb"
    static let accessTokenPath = "oauth/access_token"
    static let requestTokenPath = "oauth/request_token"
    static let authorizePath = "oauth/authorize"
    static let authUserEndPoint = "https://api.twitter.com/1.1/account/verify_credentials.json"
    static let homeTimeLineEndPoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    static let createFavorTweetEndPoint = "https://api.twitter.com/1.1/favorites/create.json?id="
    static let destroyFavorTweetEndPoint = "https://api.twitter.com/1.1/favorites/destroy.json?id="
    static let retweetCreateEndPoint = "https://api.twitter.com/1.1/statuses/retweet/" //append .json extension after append the tweet id
    static let retweetDestroyEndPoint = "https://api.twitter.com/1.1/statuses/unretweet/"
    static let TwitterClientDidDeAuthenticateNotificationName = Notification.Name("TwitterClientDidDeAuthenticateNotification")

    static let shareInstance = BDBOAuth1SessionManager(baseURL: URL(string: TwitterClient.oAuthBaseURL), consumerKey: TwitterClient.consumerKey, consumerSecret: TwitterClient.consumerSecret)
    
    class func fetchAccessTokenWithURL(url: URL, success: @escaping (BDBOAuth1Credential?) -> Void, failure: @escaping (Error?) -> Void ){
        if url.scheme == TwitterClient.oAuthURLScheme && url.host == TwitterClient.oAuthURLHost {
            let requestToken = BDBOAuth1Credential(queryString: url.query)
            let twitterClient = TwitterClient.shareInstance
            twitterClient?.fetchAccessToken(withPath: TwitterClient.accessTokenPath,
                                            method: "POST",
                                            requestToken: requestToken,
                                            success: {(credential:BDBOAuth1Credential?) in
                                                success(credential)
            },  failure: {(error:Error?) in
                failure(error)
            })
        }
   }
    
    class func logInWithTwitter(){
        TwitterClient.shareInstance?.deauthorize()
        let callbackURL = URL(string: "\(TwitterClient.oAuthURLScheme)://\(TwitterClient.oAuthURLHost)")
        TwitterClient.shareInstance?.fetchRequestToken(withPath: TwitterClient.requestTokenPath, method: "POST", callbackURL: callbackURL, scope: nil, success: { (credential: BDBOAuth1Credential?) in
            if let credential = credential{
                if let authorizeURL = URL(string: TwitterClient.oAuthBaseURL + "/" + TwitterClient.authorizePath + "?oauth_token=\(credential.token!)"){
                    UIApplication.shared.open(authorizeURL)
                }
            }
        }, failure: {(error: Error?) in
            print("failure: \(error?.localizedDescription)")
        })
    }
    
    class func getUserProfile(callBack: @escaping (_ response: User?, _ error: Error? ) -> Void){
        let _ = TwitterClient.shareInstance?.get(TwitterClient.authUserEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let userDict = response as? [String: Any]{
                let user = User(userDict: userDict)
                callBack(user, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    class func getHomeTimeLine(callBack: @escaping (_ response: [Tweet]?, _ error: Error? ) -> Void){
        let _ = TwitterClient.shareInstance?.get(TwitterClient.homeTimeLineEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let timelineDict = response as? [[String: Any]]{
                let tweets = timelineDict.map{(element) -> Tweet in
                    return Tweet(tweetDict: element)
                }
                callBack(tweets, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    
    class func toggleFavorTweet(tweet: Tweet, option: FavorToggleOption,  callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        var favorEndPoint: String
        if option == .create{
            favorEndPoint = TwitterClient.createFavorTweetEndPoint + String(tweet.id)
        }else{
            favorEndPoint = TwitterClient.destroyFavorTweetEndPoint + String(tweet.id)
        }
        
        let _ = TwitterClient.shareInstance?.post(favorEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let tweetDict = response as? [String: Any]{
                let tweet = Tweet(tweetDict: tweetDict)
                callBack(tweet, nil)
            }else{
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    
    class func toggleRetweet(tweet: Tweet, option: RetweetToggleOption,  callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        var retweetEndPoint: String
        if option == .create{
            retweetEndPoint = TwitterClient.retweetCreateEndPoint + String(tweet.id)
        }else{
            retweetEndPoint = TwitterClient.retweetDestroyEndPoint + String(tweet.id)
        }
        retweetEndPoint = retweetEndPoint + ".json"
        let _ = TwitterClient.shareInstance?.post(retweetEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let tweetDict = response as? [String: Any], let originalTweet = tweetDict["retweeted_status"] as? [String: Any]{
                    let tweet = Tweet(tweetDict: originalTweet)
                callBack(tweet, nil)
            }else{
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }

    
    class func loadMoreTweet(callBack: @escaping (_ response: [Tweet]?, _ error: Error? ) -> Void){
        var parameters: [String: Any]!
        guard let currentUser = (UIApplication.shared.delegate as? AppDelegate)?.currentUser else{
            return
        }
        parameters = ["max_id": currentUser.lowesLoadedtTimeLineId]
        let _ = TwitterClient.shareInstance?.get(TwitterClient.homeTimeLineEndPoint, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let timelineDict = response as? [[String: Any]]{
                let tweets = timelineDict.map{(element) -> Tweet in
                    return Tweet(tweetDict: element)
                }
                currentUser.timeline?.append(contentsOf: tweets)
                callBack(tweets, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })

    }
    
    

}
