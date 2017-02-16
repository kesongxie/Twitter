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
    
    
    @IBOutlet weak var loginContainerView: UIView!
    
    @IBOutlet weak var logoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToHomeAfterLoggedIn(notification:)), name: AppDelegate.FinishedLogInNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failedToLogin(notification:)), name: AppDelegate.FailedToLogInNotificationName, object: nil)

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
        print("recieved notification")
        DispatchQueue.main.async {
            if let tabBarVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.TabBarViewControllerIden) as? TabBarViewController{
                tabBarVC.transitioningDelegate = self
                self.present(tabBarVC, animated: true, completion: nil)
            }
        }
    }
    
    func failedToLogin(notification: Notification){
        self.view.bringSubview(toFront: self.loginContainerView)
    }
    
    func didLogout(notification: Notification){
        self.presentLogInVCIfNeeded()
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

extension PrepareViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.statusBarStyle = UIStatusBarStyle.default
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }
    
}

extension PrepareViewController: LogInViewControllerDelegate{
    func loginWithTwitterBtnTapped(controller: UIViewController) {
        let deadline = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            self.view.bringSubview(toFront: self.logoView)
        })
    }
}


