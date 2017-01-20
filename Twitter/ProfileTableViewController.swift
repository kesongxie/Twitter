//
//  ProfileTableViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
fileprivate let reuseIden = "TweetCell"
class ProfileTableViewController: UITableViewController {
    @IBOutlet weak var bannerImageView: UIImageView!{
        didSet{
            self.bannerImageView.layer.borderWidth = 1.0
            self.bannerImageView.layer.borderColor = UIColor(red: 200 / 255.0, green: 200 / 255.0, blue: 200 / 255.0, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            self.profileImageView.layer.cornerRadius = 6.0
            self.profileImageView.layer.borderWidth = 4.0
            self.profileImageView.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var profileActionBtn: UIButton!{
        didSet{
            self.profileActionBtn.layer.cornerRadius = 6.0
            self.profileActionBtn.layer.borderWidth = 1.0
            if self.isUsingCurrentUser{
                self.profileActionBtn.layer.borderColor = UIColor(red: 101 / 255.0, green: 119 / 255.0, blue: 134 / 255.0, alpha: 1).cgColor
            }else{
                TwitterClient.isFollowingUser(userId: self.user!.id!, callBack: { (isFollowing, error) in
                    if let following = isFollowing{
                        if following{
                            self.profileActionBtn.setTitle("Following", for: .normal)
                            self.profileActionBtn.setTitleColor(UIColor.white, for: .normal)
                            self.profileActionBtn.backgroundColor = App.themeColor
                            //add coressponding action to the following, tapped to upfollow
                        }else{
                            self.profileActionBtn.setTitle("+Follow", for: .normal)
                            self.profileActionBtn.setTitleColor(App.themeColor, for: .normal)
                            self.profileActionBtn.backgroundColor = UIColor.white
                        }
                    }
                })
                self.profileActionBtn.layer.borderColor = App.themeColor.cgColor
            }
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    

    
    @IBOutlet weak var accountBtn: UIButton!{
        didSet{
            if self.isUsingCurrentUser{
                self.accountBtn.layer.cornerRadius = 6.0
                self.accountBtn.layer.borderWidth = 1.0
                self.accountBtn.layer.borderColor = UIColor(red: 101 / 255.0, green: 119 / 255.0, blue: 134 / 255.0, alpha: 1).cgColor
            }else{
                self.accountBtn.isHidden = true
            }
        }
    }
    
    var bannerOriginalHeight: CGFloat = 0
    var tweets: [Tweet]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var user: User? = App.delegate?.currentUser{
        didSet{
            self.isUsingCurrentUser = !(self.user?.screen_name != App.delegate?.currentUser?.screen_name)
        }
    }
    
    var isUsingCurrentUser = true
    var isPresented = false
    
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            self.backBtn.isHidden = !self.isPresented
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        guard let user = self.user else{
            return
        }
        if let bannerURL = user.profileBannerURL{
            self.bannerImageView.setImageWith(bannerURL)
        }
        if let profileImageURL = user.profileImageURL{
            self.profileImageView.setImageWith(profileImageURL)
        }
        self.nameLabel.text = user.name
        self.screenNameLabel.text = "@" + user.screen_name
        self.bioLabel.text = user.description
        self.followerCountLabel.text = String(user.followerCount)
        self.followingCountLabel.text = String(user.followingCount)
        self.segmentControl.tintColor = App.themeColor

        TwitterClient.getUserProfileTimeLine(userScreenName: user.screen_name) { (tweets, error) in
            if let tweets = tweets{
                self.tweets = tweets
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bannerImageView.frame.size.width = self.view.frame.size.width
        self.bannerOriginalHeight = self.view.frame.size.width / App.bannerAspectRatio
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        self.headerView.frame.size.height = height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setLogoutBtn(){
        //        self.logoutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBtnTapped(sender:)))
        //        self.logoutBtn?.tintColor = UIColor.black
        //        self.navigationItem.leftBarButtonItem = self.logoutBtn
    }
    
    
    
    func logoutBtnTapped(sender: UIBarButtonItem){
        UserDefaults.resetStandardUserDefaults()
        TwitterClient.shareInstance?.deauthorize()
        self.dismiss(animated: true, completion: {
            let logOutNotification = Notification(name: TwitterClient.TwitterClientDidDeAuthenticateNotificationName, object: self, userInfo: nil)
            NotificationCenter.default.post(logOutNotification)
        })
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0{
            self.topSpaceConstraint.constant = scrollView.contentOffset.y
            self.bannerHeightConstraint.constant = self.bannerOriginalHeight - scrollView.contentOffset.y
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tweets?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! TweetTableViewCell
        cell.tweet =  self.tweets![indexPath.row]
        return cell

    }

}
