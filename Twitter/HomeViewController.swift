//
//  HomeViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "TweetCell"

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    var logoutBtn: UIBarButtonItem?
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView set up
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.setLogoutBtn()
        self.refreshControl.addTarget(self, action: #selector(refreshDragged(sender:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        if self.user?.timeline != nil{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refreshDragged(sender: UIRefreshControl){
        TwitterClient.getHomeTimeLine { (tweets, error) in
            self.user?.timeline = tweets
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    func setLogoutBtn(){
        self.logoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBtnTapped(sender:)))
        self.logoutBtn?.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = self.logoutBtn
    }
    
    func logoutBtnTapped(sender: UIBarButtonItem){
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user?.timeline?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! TweetTableViewCell
        cell.tweet =  self.self.user!.timeline![indexPath.row]
        return cell
    }

}
