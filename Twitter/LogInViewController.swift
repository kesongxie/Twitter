//
//  ViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/14/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

protocol LogInViewControllerDelegate: class{
    func loginWithTwitterBtnTapped(controller: UIViewController);
}

class LogInViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginWithTwitterBtn: UIButton!{
        didSet{
            self.loginWithTwitterBtn.layer.cornerRadius = 4.0
        }
    }
    @IBAction func loginWithTwitterBtnTapped(_ sender: UIButton) {
        if let delegate = delegate{
            TwitterClient.logInWithTwitter()
            delegate.loginWithTwitterBtnTapped(controller: self)
        }
    }
    
    var statusBarStyle: UIStatusBarStyle?
    
    let animator = HorizontalSliderAnimator()
    
    weak var delegate: LogInViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.alwaysBounceVertical = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        App.postStatusBarShouldUpdateNotification(style: .lightContent)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension LogInViewController: UIViewControllerTransitioningDelegate{
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


