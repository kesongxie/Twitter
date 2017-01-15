//
//  TwitterClient.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import BDBOAuth1Manager

class TwitterClient{
    static let oAuthURLScheme = "twitter"
    static let oAuthURLHost = "oauth"
    static let oAuthBaseURL = "https://api.twitter.com"
    static let consumerKey = "xYcPZaVMALn2EjHCuv7vqzcZD"
    static let consumerSecret = "BClWlCqNRZAh3UHxA1bbFKXMPfqgmk5F3soY7Dbbz9JOhuvyDS"
    static let accessTokenPath = "oauth/access_token"
    static let requestTokenPath = "oauth/request_token"
    static let authorizePath = "oauth/authorize"
    static let authUserEndPoint = "https://api.twitter.com/1.1/account/verify_credentials.json"
    static let homeTimeLineEndPoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    
    
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
    

}
