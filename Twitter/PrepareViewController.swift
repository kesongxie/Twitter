//
//  PrepareViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class PrepareViewController: UIViewController {

    var animator = HorizontalSliderAnimator()
    
    var isLoggedInScreenPresented = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToHomeAfterLoggedIn(notification:)), name: AppDelegate.FinishedLogInNotificationName, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout(notification:)), name: TwitterClient.TwitterClientDidDeAuthenticateNotificationName, object: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let user = User.getCurrentUser(){
            if let homeNVC =  storyboard.instantiateViewController(withIdentifier: StorybordIdentifier.HomeNavigationViewControllerIden) as? HomeNavigationViewController{
                if let homeVC = homeNVC.viewControllers.first as? HomeViewController{
                    homeVC.user = user
                    homeNVC.modalPresentationStyle = .custom
                    homeNVC.transitioningDelegate = self
                    DispatchQueue.main.async {
                        self.present(homeNVC, animated: true, completion: nil)
                    }
                }
            }
        }else{
            self.presentLogInVCIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func navigateToHomeAfterLoggedIn(notification: Notification){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let user = notification.userInfo![AppDelegate.FinishedLogInUserInfoKey] as? User{
            if let homeNVC =  storyboard.instantiateViewController(withIdentifier: StorybordIdentifier.HomeNavigationViewControllerIden) as? HomeNavigationViewController{
                if let homeVC = homeNVC.viewControllers.first as? HomeViewController{
                    homeVC.user = user
                    homeNVC.modalPresentationStyle = .custom
                    homeNVC.transitioningDelegate = (self.presentedViewController as! LogInViewController)
                    DispatchQueue.main.async {
                        self.presentedViewController?.present(homeNVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func didLogout(notification: Notification){
        self.presentLogInVCIfNeeded()
    }
    
    func presentLogInVCIfNeeded(){
        if !self.isLoggedInScreenPresented{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: StorybordIdentifier.LogInViewControllerIden) as? LogInViewController{
                DispatchQueue.main.async {
                    self.isLoggedInScreenPresented = true
                    self.present(loginVC, animated: true, completion: nil)
                }
            }
        }
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
}

extension PrepareViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
}
