//
//  MessageViewController.swift
//  Twitter
//
//  Created by Xie kesong on 2/17/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit


fileprivate let reuseIden = "MessageSuggestCell"

class MessageViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    var suggestedUsers:[User]?{
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        guard let currentUser = App.delegate?.currentUser else{
            return
        }
        TwitterClient.getFriends(userScreenName: currentUser.screen_name, option: .following) { (followings, error) in
            if let followings = followings{
                self.suggestedUsers = followings
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        App.postStatusBarShouldUpdateNotification(style: .default)
    }
    

}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestedUsers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! SuggestMessageTableViewCell
        cell.user = self.suggestedUsers![indexPath.row]
        return cell
    }
}






