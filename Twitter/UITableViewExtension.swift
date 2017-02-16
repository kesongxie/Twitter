//
//  UITableViewExtension.swift
//  Twitter
//
//  Created by Xie kesong on 2/14/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//


import UIKit

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableHeaderView(header: UIView) {
        header.setNeedsLayout()
        header.layoutIfNeeded()
        header.frame.size = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        self.tableHeaderView = header
    }
}
