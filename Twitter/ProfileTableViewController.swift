//
//  ProfileTableViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/18/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
fileprivate let reuseIden = "TweetCell"
fileprivate let tweetCellNibName = "TweetTableViewCell"

class ProfileTableViewController: UITableViewController {
    @IBOutlet weak var bannerImageView: UIImageView!
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
    
    
    @IBOutlet weak var headerActivityIndicatorView: UIActivityIndicatorView!
    
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
    
    @IBOutlet weak var backBtn: UIButton!{
        didSet{
            self.backBtn.isHidden = !self.isPresented
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var downArrowImageView: UIImageView!

    
    var bannerOriginalHeight: CGFloat = 0
    var tweets: [Tweet]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var mediaFilteredTweet: [Tweet]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var favoritesList: [Tweet]?{
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var user: User? = App.delegate?.currentUser{
        didSet{
            self.isUsingCurrentUser = !(self.user?.screen_name != App.delegate?.currentUser?.screen_name)
        }
    }
    
    var isUsingCurrentUser = true
    var isPresented = false
    var isViewDidAppear = false
    lazy var context = CIContext()
    var filter: CIFilter!
    var ciImage: CIImage?
    
    //state control for header view arrow animation
    var isAnimating = false

    var shouldHideStatusBar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filter = CIFilter(name: "CIGaussianBlur")
        let nib = UINib(nibName: tweetCellNibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: reuseIden)
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        guard let user = self.user else{
            return
        }
        if let bannerURL = user.profileBannerURL{
            let urlRequest = URLRequest(url: bannerURL)
            self.bannerImageView.setImageWith(urlRequest, placeholderImage: nil, success: { (request, response, image) in
                self.bannerImageView.image = image
                self.ciImage = CIImage(cgImage: image.cgImage!)
                self.filter.setValue(self.ciImage, forKey: kCIInputImageKey)
            }, failure: nil)
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
        self.loadData(completion: nil)
        
        self.segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isViewDidAppear{
            self.bannerOriginalHeight = self.headerView.frame.size.width /  App.bannerAspectRatio
            self.bannerHeightConstraint.constant = self.bannerOriginalHeight
            self.isViewDidAppear = true
            self.tableView.setAndLayoutTableHeaderView(header: self.headerView)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0{
            self.topSpaceConstraint.constant = scrollView.contentOffset.y
            self.bannerHeightConstraint.constant = self.bannerOriginalHeight - scrollView.contentOffset.y
            self.filter.setValue(-scrollView.contentOffset.y * 0.1, forKey: "inputRadius")
            if !self.isAnimating{
                self.downArrowImageView.alpha = min(1, -scrollView.contentOffset.y * 0.02)
            }
            if let cgimg = context.createCGImage(filter.outputImage!, from: ciImage!.extent) {
                let blurImage = UIImage(cgImage: cgimg)
                self.bannerImageView.image = blurImage
            }
        }
    }
    
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.downArrowImageView.alpha == 1 &&  !self.isAnimating{
            let transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            self.isAnimating = true
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.downArrowImageView.transform = transform
            }, completion: { (finished) in
                if finished{
                    self.downArrowImageView.alpha = 0
                    self.headerActivityIndicatorView.isHidden = false
                    self.headerActivityIndicatorView.startAnimating()
                    self.downArrowImageView.transform = .identity
                    self.isAnimating = false
                    self.loadData(completion: {
                        self.headerActivityIndicatorView.stopAnimating()
                    })
                }
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool{
        return self.shouldHideStatusBar
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .fade
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch self.segmentControl.selectedSegmentIndex{
        case 0:
            return self.tweets?.count ?? 0
        case 1:
            return self.mediaFilteredTweet?.count ?? 0
        case 2:
            return self.favoritesList?.count ?? 0
        default:
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! TweetTableViewCell
        switch self.segmentControl.selectedSegmentIndex{
        case 0:
            cell.tweet =  self.tweets![indexPath.row]
        case 1:
            cell.tweet =  self.mediaFilteredTweet![indexPath.row]
        case 2:
            cell.tweet = self.favoritesList![indexPath.row]
        default:
            break
        }
        return cell
    }
    
    func logoutBtnTapped(sender: UIBarButtonItem){
        UserDefaults.resetStandardUserDefaults()
        TwitterClient.shareInstance?.deauthorize()
        self.dismiss(animated: true, completion: {
            let logOutNotification = Notification(name: TwitterClient.TwitterClientDidDeAuthenticateNotificationName, object: self, userInfo: nil)
            NotificationCenter.default.post(logOutNotification)
        })
    }
    
    /** load user's home timeline
     */
    func loadData(completion completionHandlder:  ((Void) -> Void)? ){
        guard let user = self.user else{
            return
        }
        TwitterClient.getUserProfileTimeLine(userScreenName: user.screen_name) { (tweets, error) in
            if let tweets = tweets{
                self.tweets = tweets
                if let completion = completionHandlder{
                    completion()
                }
            }
        }
    }
    
    /*
     * sement control value changed event
     */
    
    func segmentControlValueChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            //home default tweets
            self.tableView.reloadData()
        case 1:
            self.mediaFilteredTweet = self.tweets?.filter({ (tweet) -> Bool in
                tweet.photos != nil
            })
        case 2:
            //likes
            TwitterClient.getUserFavoritesList(callBack: { (tweets, error) in
                if let tweets = tweets{
                    self.favoritesList = tweets
                }
            })
        default:
            break
        }
    }

    
    
    
  }
