//
//  PrepareNavigationViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class PrepareNavigationViewController: UINavigationController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(navigateToHomeAfterLoggedIn(notification:)), name: AppDelegate.FinishedLogInNotificationName, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController?{
        return self.viewControllers.last
    }
    
    func navigateToHomeAfterLoggedIn(notification: Notification){
        if let user = notification.userInfo![AppDelegate.FinishedLogInUserInfoKey] as? User{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let homeVC = storyboard.instantiateViewController(withIdentifier: StorybordIdentifier.HomeViewController) as? HomeViewController{
                homeVC.user = user
                self.pushViewController(homeVC, animated: true)
            }
        }
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
