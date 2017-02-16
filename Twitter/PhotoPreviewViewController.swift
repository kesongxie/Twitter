//
//  PhotoPreviewViewController.swift
//  Twitter
//
//  Created by Xie kesong on 2/15/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.maximumZoomScale = 3.0
            self.scrollView.delegate = self
        }
    }
    lazy var photoImageView = UIImageView()
    
    var tweet: Tweet?
    var image: UIImage?{
        didSet{
            self.photoImageView.image = image
        }
    }
    
    @IBAction func closeIconTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.alwaysBounceVertical = true
        // Do any additional setup after loading the view.
        self.photoImageView.frame.size = UIScreen.main.bounds.size
        self.photoImageView.contentMode = .scaleAspectFit
        self.scrollView.contentSize = self.photoImageView.frame.size
        self.scrollView.addSubview(self.photoImageView)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension PhotoPreviewViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -60{
            self.dismiss(animated: true, completion: nil)
        }
    }
}


