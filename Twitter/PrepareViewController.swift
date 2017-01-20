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
    
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToHomeAfterLoggedIn(notification:)), name: AppDelegate.FinishedLogInNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didLogout(notification:)), name: TwitterClient.TwitterClientDidDeAuthenticateNotificationName, object: nil)
        if let _ = User.getCurrentUser(){
            if let tabBarVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.TabBarViewControllerIden) as? TabBarViewController{
                tabBarVC.transitioningDelegate = self
                DispatchQueue.main.async {
                    self.present(tabBarVC, animated: true, completion: nil)
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
        DispatchQueue.main.async {
            if let tabBarVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.TabBarViewControllerIden) as? TabBarViewController{
                tabBarVC.transitioningDelegate = self
                    self.presentedViewController?.present(tabBarVC, animated: true, completion: nil)
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
        return self.statusBarStyle
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
    
    
}

extension PrepareViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.statusBarStyle = UIStatusBarStyle.default
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.view .layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
}
