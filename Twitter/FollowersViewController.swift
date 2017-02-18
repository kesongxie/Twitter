//
//  FollowersTableViewController.swift
//  Twitter
//
//  Created by Xie kesong on 2/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "FollowerCell"

class FollowersViewController: UIViewController {
    
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
            TwitterClient.getFriends(userScreenName: self.user!.screen_name, option: .followers) { (followers, error) in
                if let followers = followers{
                    self.followers = followers
                }
            }
        }
    }
    
   
    var followers: [User]?{
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
extension FollowersViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! FollowersTableViewCell
        cell.user = self.followers![indexPath.row]
        return cell
    }

}
