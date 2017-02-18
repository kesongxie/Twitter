//
//  FollowingTableViewController.swift
//  Twitter
//
//  Created by Xie kesong on 2/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "FollowingCell"

class FollowingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    @IBOutlet weak var footerView: UIView!
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    var user: User?{
        didSet{
            TwitterClient.getFriends(userScreenName: self.user!.screen_name, option: .following) { (followings, error) in
                if let followings = followings{
                    self.followings = followings
                }
            }
        }
    }
    
    
    var followings: [User]?{
        didSet{
            DispatchQueue.main.async {
                self.footerView.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        App.postStatusBarShouldUpdateNotification(style: .default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Table view data source, delegate
extension FollowingViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followings?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! FollowingTableViewCell
        cell.user = self.followings![indexPath.row]
        return cell
    }
    
}
