//
//  PrepareViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let loginEmbedSgue = "loginEmbedSgue"

class PrepareViewController: UIViewController {

    var animator = HorizontalSliderAnimator()
    
    var isLoggedInScreenPresented = false
    
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    
    @IBOutlet weak var twitterBird: UIImageView!
    
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var homeContainerView: UIView!
    
    @IBOutlet weak var logoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToHomeAfterLoggedIn(notification:)), name: AppDelegate.FinishedLogInNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedToLogin(notification:)), name: AppDelegate.FailedToLogInNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout(notification:)), name: TwitterClient.TwitterClientDidDeAuthenticateNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusBarShouldUpdate(notification:)), name: AppNotification.statusBarShouldUpdateNotificationName, object: nil)

        
        if let _ = User.getCurrentUser(){
            self.zoomAnimate(completion: {
                self.view.bringSubview(toFront: self.homeContainerView)
            })
        }else{
            self.presentLogInVCIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func zoomAnimate(completion completionHandler: @escaping (Void)-> Void){
        let zoomOutTransfrom = CGAffineTransform(scaleX: 0.93, y: 0.93)
        let zoomInTransfrom = CGAffineTransform(scaleX: 30, y: 30)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.twitterBird.transform = zoomOutTransfrom
        }) { (finished) in
            if finished{
                UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseInOut, animations: {
                    self.twitterBird.transform = zoomInTransfrom
                }, completion: { (finished) in
                    if finished{
                        self.twitterBird.transform = .identity
                        self.statusBarStyle = .default
                        self.setNeedsStatusBarAppearanceUpdate()
                        completionHandler()
                    }
                })
            }
        }
    }
    
    
    func navigateToHomeAfterLoggedIn(notification: Notification){
        DispatchQueue.main.async {
            self.zoomAnimate(completion: {
                let notification = Notification(name: AppNotification.homeTimeLineShouldRefreshNotificationName, object: self, userInfo: nil)
                NotificationCenter.default.post(notification)
                self.view.bringSubview(toFront: self.homeContainerView)
            })
        }
    }
    
    func failedToLogin(notification: Notification){
        self.view.bringSubview(toFront: self.loginContainerView)
    }
    
    func didLogout(notification: Notification){
        self.presentLogInVCIfNeeded()
    }
    
    func statusBarShouldUpdate(notification: Notification){
        if let statusBarStyle = notification.userInfo?[AppNotification.statusBarStyleKey] as? UIStatusBarStyle{
            self.statusBarStyle = statusBarStyle
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func presentLogInVCIfNeeded(){
        if !self.isLoggedInScreenPresented{
            self.view.bringSubview(toFront: self.loginContainerView)
        }
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginEmbedSgue{
            if let loginVC = segue.destination as? LogInViewController{
                loginVC.delegate = self
            }
        }
    }
    
}

//extension PrepareViewController: UIViewControllerTransitioningDelegate{
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        self.statusBarStyle = UIStatusBarStyle.default
//        self.view.setNeedsLayout()
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//            self.setNeedsStatusBarAppearanceUpdate()
//        }
//        return animator
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return animator
//    }
//    
//}

extension PrepareViewController: LogInViewControllerDelegate{
    func loginWithTwitterBtnTapped(controller: UIViewController) {
        let deadline = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            self.view.bringSubview(toFront: self.logoView)
        })
    }
}


