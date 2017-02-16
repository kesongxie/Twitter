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
    static let TwitterClientDidDeAuthenticateNotificationName = Notification.Name("TwitterClientDidDeAuthenticateNotification")
    
    static let oAuthURLScheme = "twitter-codepath"
    static let oAuthURLHost = "oauth"
    static let oAuthBaseURL = "https://api.twitter.com"
    static let consumerKey = "nmhiqaGusZzzHB65sToh5BIyg"
    static let consumerSecret = "fk0RVOSp3uF0M3dFjO1XStaByYKJw50aqKzKjX4wu5mqXDYNlM"
    static let accessTokenPath = "oauth/access_token"
    static let requestTokenPath = "oauth/request_token"
    static let authorizePath = "oauth/authorize"
    static let authUserEndPoint = "https://api.twitter.com/1.1/account/verify_credentials.json"
    static let homeTimeLineEndPoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    static let userProfieTimeLineEndPoint = oAuthBaseURL + "/1.1/statuses/user_timeline.json"

    static let createFavorTweetEndPoint = oAuthBaseURL + "/1.1/favorites/create.json"
    static let destroyFavorTweetEndPoint = oAuthBaseURL + "/1.1/favorites/destroy.json"
    static let retweetCreateEndPoint = "https://api.twitter.com/1.1/statuses/retweet/" //append .json extension after append the tweet id
    static let retweetDestroyEndPoint = "https://api.twitter.com/1.1/statuses/unretweet/"
    static let sendTweetEndPoint = "https://api.twitter.com/1.1/statuses/update.json?status="
    static let friendShipLookUpEndPoint = "https://api.twitter.com/1.1/friendships/lookup.json"
    
    static let  favoritesListEndPoint = oAuthBaseURL + "/1.1/favorites/list.json"
    
    
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
                App.delegate?.currentUser?.timeline = tweets
                callBack(tweets, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    class func getUserProfileTimeLine(userScreenName: String, callBack: @escaping (_ response: [Tweet]?, _ error: Error? ) -> Void){
        let fetchURLString = self.userProfieTimeLineEndPoint
        let param: [String : Any] = ["count": 100, "screen_name": userScreenName]
        let _ = TwitterClient.shareInstance?.get(fetchURLString, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
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

    /** get the authenticated user favorite list
     */
    class func getUserFavoritesList(callBack: @escaping (_ response: [Tweet]?, _ error: Error? ) -> Void){
        if let currentUser = App.delegate?.currentUser{
            let fetchURLString = self.favoritesListEndPoint
            let param: [String : Any] = ["count": 100, "screen_name": currentUser.screen_name]
            let _ = TwitterClient.shareInstance?.get(fetchURLString, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
                if let tweetList = response as? [[String: Any]]{
                    let tweets = tweetList.map{(element) -> Tweet in
                        return Tweet(tweetDict: element)
                    }
                    callBack(tweets, nil)
                }
            }, failure: { (task: URLSessionDataTask?, error:Error) in
                print(error.localizedDescription)
                callBack(nil, error)
            })
        }
    }
    
    class func toggleFavorTweet(tweet: Tweet, option: FavorToggleOption,  callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        var favorEndPoint: String
        if option == .create{
            favorEndPoint = TwitterClient.createFavorTweetEndPoint
        }else{
            favorEndPoint = TwitterClient.destroyFavorTweetEndPoint
        }
        
        let param = ["id": String(tweet.id)]
        let _ = TwitterClient.shareInstance?.post(favorEndPoint, parameters: param, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
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
                if let tweetDict = response as? [String: Any]{
                    var tweet: Tweet?
                    if option == .create{
                        if let originalTweetDict = tweetDict["retweeted_status"] as? [String: Any]{
                            tweet = Tweet(tweetDict: originalTweetDict)
                        }
                    }else{
                         tweet = Tweet(tweetDict: tweetDict)
                    }
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
                App.delegate?.currentUser?.timeline?.append(contentsOf: tweets)
                callBack(tweets, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    class func sendTweet(text: String, callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{
            callBack(nil, nil)
            return
        }
        let urlString = TwitterClient.sendTweetEndPoint + encodedText
        let _ = TwitterClient.shareInstance?.post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let tweetDict = response as? [String: Any]{
                let tweet = Tweet(tweetDict: tweetDict)
                App.delegate?.currentUser?.timeline?.insert(tweet, at: 0)
                callBack(tweet, nil)
            }else{
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    class func isFollowingUser(userId: UInt,  callBack: @escaping (_ response: Bool?, _ error: Error? ) -> Void){
        let userIdDict = ["user_id": userId]
        let _ = TwitterClient.shareInstance?.get(TwitterClient.friendShipLookUpEndPoint, parameters: userIdDict, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let friendShipDict = (response as? [[String: Any]])?.first{
                if let connection = friendShipDict["connections"] as? [String]{
                    callBack((connection.index(of: "following") != nil), nil)
                }else{
                    callBack(nil, nil)
                }
            }else{
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    
    
    
}
