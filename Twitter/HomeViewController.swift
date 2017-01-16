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
    @IBOutlet weak var footerLoadingView: UIView!

    
    let refreshControl = UIRefreshControl()
    var logoutBtn: UIBarButtonItem?
    var user: User?
    var isLoadingData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView set up
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        let image = UIImage(named: "TwitterLogoBlue")
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = image
        self.navigationItem.titleView = logoImageView
        
        self.setLogoutBtn()
        self.refreshControl.addTarget(self, action: #selector(refreshDragged(sender:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        refreshTimeLine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refreshDragged(sender: UIRefreshControl){
        self.refreshTimeLine()
    }
    
    func refreshTimeLine(){
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
        TwitterClient.shareInstance?.deauthorize()
        self.dismiss(animated: true, completion: {
            let logOutNotification = Notification(name: TwitterClient.TwitterClientDidDeAuthenticateNotificationName, object: self, userInfo: nil)
            NotificationCenter.default.post(logOutNotification)
        })
    }
    
    func loadMoreEntries(){
        TwitterClient.loadMoreTweet { (newTweets, error) in
            if let newTweets = newTweets, newTweets.count > 0{
                self.isLoadingData = false
                self.user?.timeline?.append(contentsOf: newTweets)
                DispatchQueue.main.async {
                    self.footerLoadingView.isHidden = true
                    self.tableView.reloadData()
                }
            }else{
                self.footerLoadingView.isHidden = true
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!self.isLoadingData){
            if(scrollView.contentOffset.y > scrollView.contentSize.height - self.view.frame.size.height){
                self.isLoadingData = true
                self.loadMoreEntries()
            }
        }
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
