//
//  PrepareViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class PrepareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let user = User.getCurrentUser(){
            if let homeVC = storyboard.instantiateViewController(withIdentifier: StorybordIdentifier.HomeViewController) as? HomeViewController{
                homeVC.user = user
                self.navigationController?.pushViewController(homeVC, animated: true)
            }
        }else{
            self.navigationController?.navigationBar.isHidden = true
            if let loginVC = storyboard.instantiateViewController(withIdentifier: StorybordIdentifier.LogInViewControllerIden) as? LogInViewController{
                DispatchQueue.main.async {
                    self.navigationController?.present(loginVC, animated: true, completion: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
