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
    var isLoadingData: Bool = false
    
    @IBOutlet weak var addFriendBtn: UIBarButtonItem!{
        didSet{
            self.addFriendBtn.tintColor = App.themeColor
        }
    }
    
    @IBOutlet weak var composeBtn: UIBarButtonItem!{
        didSet{
            self.composeBtn.tintColor = App.themeColor
        }
    }
    
    fileprivate var animator = HorizontalSliderAnimator()
    
    var statusBarStyle: UIStatusBarStyle = .default

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView set up
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTweet(notification:)), name: AppNotification.tweetDidSendNotificationName, object: nil)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        let image = UIImage(named: "TwitterLogoBlue")
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = image
        self.navigationItem.titleView = logoImageView
        self.refreshControl.addTarget(self, action: #selector(refreshDragged(sender:)), for: .valueChanged)
        self.tableView.refreshControl = self.refreshControl
        refreshTimeLine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    
    func didTweet(notification: Notification){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
  
    
    func refreshDragged(sender: UIRefreshControl){
        self.refreshTimeLine()
    }
    
    func refreshTimeLine(){
        TwitterClient.getHomeTimeLine { (tweets, error) in
            App.delegate?.currentUser?.timeline = tweets
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }

    }

    func loadMoreEntries(){
        TwitterClient.loadMoreTweet { (newTweets, error) in
            if let newTweets = newTweets, newTweets.count > 0{
                self.isLoadingData = false
                App.delegate?.currentUser?.timeline?.append(contentsOf: newTweets)
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
    
    func shouldPushUserProfileHandler(gesture: UIGestureRecognizer){
        if let profileVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.ProfileTableViewControllerIden) as? ProfileTableViewController{
            if let cell = gesture.view?.superview?.superview as? TweetTableViewCell{
                profileVC.isPresented = true
                profileVC.user = cell.tweet.user
                profileVC.transitioningDelegate = self
                self.present(profileVC, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let iden = segue.identifier{
            if iden == SegueIdentifier.showTweetDetail{
                guard let tweetDetailVC = segue.destination as? TweetDetailViewController else{
                    return
                }
                guard let selectedIndexPath = sender as? IndexPath else{
                    return
                }
                
                guard let selectedTweet = App.delegate?.currentUser?.timeline?[selectedIndexPath.row] else{
                    return
                }
                tweetDetailVC.tweet = selectedTweet
            }
        }
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.delegate?.currentUser?.timeline?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! TweetTableViewCell
        //tap for userImageView
        let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(shouldPushUserProfileHandler(gesture:)))
        cell.userImageView.addGestureRecognizer(userProfileTap)        
        cell.tweet =  App.delegate?.currentUser?.timeline![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SegueIdentifier.showTweetDetail, sender: indexPath)
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.statusBarStyle = UIStatusBarStyle.lightContent
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.view .layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.statusBarStyle = UIStatusBarStyle.default
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3) {
            self.view .layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }
        return animator
    }
    
}
