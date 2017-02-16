//
//  HomeViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "TweetCell"
fileprivate let tweetCellNibName = "TweetTableViewCell"

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
        
        self.tableView.register(UINib(nibName: tweetCellNibName, bundle: Bundle.main), forCellReuseIdentifier: reuseIden)

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
            if error == nil{
                DispatchQueue.main.async {
                    //the home time line of the current user will be updating after this call if suceed
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }

    }

    func loadMoreEntries(){
        TwitterClient.loadMoreTweet { (newTweets, error) in
            if error == nil{
                DispatchQueue.main.async {
                    self.isLoadingData = false
                    self.tableView.reloadData()
                }
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
        cell.tweet = App.delegate?.currentUser?.timeline?[indexPath.row]
        cell.delegate = self
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
            self.view.layoutIfNeeded()
            self.setNeedsStatusBarAppearanceUpdate()
        }
        return animator
    }
}

extension HomeViewController: TweetTableViewCellDelegate{
    func mediaImageViewTapped(cell: TweetTableViewCell, image: UIImage?, tweet: Tweet) {
        if let previewDetailVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.PhotoPreviewViewControllerIden) as? PhotoPreviewViewController{
            previewDetailVC.tweet = tweet
            previewDetailVC.image = image
            self.present(previewDetailVC, animated: true, completion: nil)
        }
    }
    
    func profileImageViewTapped(cell: TweetTableViewCell, tweet: Tweet) {
        if let profileVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.ProfileTableViewControllerIden) as? ProfileTableViewController{
            profileVC.isPresented = true
            profileVC.user = tweet.user
            profileVC.transitioningDelegate = self
            self.present(profileVC, animated: true, completion: nil)
        }
    }
}
