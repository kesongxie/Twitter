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

protocol ProfileTableViewControllerDelegate: class  {
    func viewWillAppear(controller: UIViewController)
}


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
            if self.isUsingCurrentUser{
                self.profileActionBtn.becomeEditProfieBtn()
            }else{
                TwitterClient.isFollowingUser(userId: self.user!.id!, callBack: { (isFollowing, error) in
                    if let following = isFollowing{
                        if following{
                            self.profileActionBtn.becomeFollowingBtn()
                        }else{
                            self.profileActionBtn.becomeFollowBtn()
                        }
                    }
                })
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
                self.accountBtn.becomeAccountBtn()
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
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    //location
    @IBOutlet weak var locationIconBtn: UIButton!
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var linkIconBtn: UIButton!
    @IBOutlet weak var linkStackView: UIStackView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var accountBtnWidthConstraint: NSLayoutConstraint!
    weak var delegate: ProfileTableViewControllerDelegate?
    
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
        @IBOutlet weak var settingIcon: UIButton!

    var isUsingCurrentUser = true
    
    var isPresented = false
    var isViewDidAppear = false
    lazy var context = CIContext()
    var filter: CIFilter!
    var ciImage: CIImage?
    
    //state control for header view arrow animation
    var isAnimating = false
    var shouldHideStatusBar: Bool = false
    
    fileprivate var animator = HorizontalSliderAnimator()
    var statusBarStyle: UIStatusBarStyle = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filter = CIFilter(name: "CIGaussianBlur")
        
        //table view set up
        let nib = UINib(nibName: tweetCellNibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: reuseIden)
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //update UI based on th current profile user
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
        
        if let location = user.location, !location.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines).isEmpty{
            print(location)
            self.locationIconBtn.setTitle(location, for: .normal)
        }else{
            //location not set
            self.locationStackView.isHidden = true
        }
        
        
        if let displayUrl = user.embedURLs?.displayUrl{
            self.linkIconBtn.setTitle(displayUrl, for: .normal)
        }else{
            //location not set
            self.linkStackView.isHidden = true
        }
        
        if self.isUsingCurrentUser{
            self.accountBtnWidthConstraint.constant = 50
        }
        
        self.nameLabel.text = user.name
        self.screenNameLabel.text = "@" + user.screen_name
        self.bioLabel.text = user.description
        self.followerCountLabel.text = user.followerCountString
        self.followingCountLabel.text = user.followingCountString
        self.segmentControl.tintColor = App.themeColor
        self.segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        self.loadData(completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isViewDidAppear{
            self.bannerOriginalHeight = self.headerView.frame.size.width /  App.bannerAspectRatio
            self.bannerHeightConstraint.constant = self.bannerOriginalHeight
        }
        App.postStatusBarShouldUpdateNotification(style: .lightContent)
        self.navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isViewDidAppear{
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
            guard let outputImage = filter.outputImage, let ciImage = self.ciImage else{
                return
            }
            if let cgimg = context.createCGImage(outputImage, from: ciImage.extent) {
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
            }else if iden == SegueIdentifier.ShowWebSegueIden{
                if let webVC = segue.destination as? WebViewController{
                    webVC.urlString =  self.user?.embedURLs?.expandedUrl
                }
            }else if iden == SegueIdentifier.ShowFollowersSegueIden{
                if let followerVC = segue.destination as? FollowersViewController{
                    followerVC.user =  self.user
                }
            }else if iden == SegueIdentifier.ShowFollowingSegueIden{
                if let followingVC = segue.destination as? FollowingViewController{
                    followingVC.user =  self.user
                }
            }
        }
    }

    
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
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
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: SegueIdentifier.showTweetDetail, sender: indexPath)
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
            guard let user = self.user else{
                return
            }
            TwitterClient.getUserFavoritesList(userScreenName: user.screen_name, callBack: { (tweets, error) in
                if let tweets = tweets{
                    self.favoritesList = tweets
                }
            })
        default:
            break
        }
    }
}


extension ProfileTableViewController: TweetTableViewCellDelegate{
    func mediaImageViewTapped(cell: TweetTableViewCell, image: UIImage?, tweet: Tweet) {
        if let previewDetailVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.PhotoPreviewViewControllerIden) as? PhotoPreviewViewController{
            previewDetailVC.tweet = tweet
            previewDetailVC.image = image
            self.present(previewDetailVC, animated: true, completion: nil)
        }
    }
    
    func profileImageViewTapped(cell: TweetTableViewCell, tweet: Tweet) {
        if let profileVC = App.mainStoryBoard.instantiateViewController(withIdentifier: StorybordIdentifier.ProfileTableViewControllerIden) as? ProfileTableViewController{
            profileVC.user = tweet.user
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}

