//
//  NotificationViewController.swift
//  Twitter
//
//  Created by Xie kesong on 2/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "TweetCell"
fileprivate let tweetCellNibName = "TweetTableViewCell"
fileprivate let notificationSectionHeaderReuseIden = "NotificationSectionHeader"

class NotificationViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            //use xib for reuse cell
            self.tableView.register(UINib(nibName: tweetCellNibName, bundle: Bundle.main), forCellReuseIdentifier: reuseIden)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.estimatedRowHeight = self.tableView.rowHeight
            self.tableView.rowHeight = UITableViewAutomaticDimension
            
        }
    }
    @IBOutlet weak var footerLoadingView: UIView!

    var tweets: [Tweet]?{
        didSet{
            self.footerLoadingView.isHidden = true
            self.tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.getMentionedTimeLine { (tweets, error) in
            if let tweets = tweets{
                self.tweets = tweets
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        App.postStatusBarShouldUpdateNotification(style: .default)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                
                guard let selectedTweet = self.tweets?[selectedIndexPath.row] else{
                    return
                }
                tweetDetailVC.tweet = selectedTweet
            }
        }

    }
}


extension NotificationViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! TweetTableViewCell
        cell.tweet = self.tweets![indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SegueIdentifier.showTweetDetail, sender: indexPath)
    }
}

extension NotificationViewController: TweetTableViewCellDelegate{
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
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

