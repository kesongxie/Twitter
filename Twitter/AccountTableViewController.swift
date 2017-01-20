//
//  AccountTableViewController.swift
//  Twitter
//
//  Created by Xie kesong on 1/19/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

fileprivate let reuseIden = "AccountCell"

class AccountTableViewController: UITableViewController {

    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        TwitterClient.logInWithTwitter()
    }
    
    @IBAction func doneBtnTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return App.delegate?.accounts.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIden, for: indexPath) as! AccountTableViewCell
        cell.selectedImageView.isHidden = !(indexPath.row == 0)
        cell.user = App.delegate?.accounts[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
        }
    }
 
}
