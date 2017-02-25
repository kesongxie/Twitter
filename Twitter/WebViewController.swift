//
//  WebViewController.swift
//  Twitter
//
//  Created by Xie kesong on 2/16/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var errorLoadingView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var urlString: String!{
        didSet{
            print(urlString)
            if let urlString = self.urlString{
                if let url = URL(string: urlString){
                    print(url)
                    self.urlRequest = URLRequest(url: url)
                }
            }
        }
    }
    
    var urlRequest: URLRequest!
        
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    lazy var timer = Timer()
    var isWebFinishLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        App.postStatusBarShouldUpdateNotification(style: .default)
        self.navigationItem.title = "Loading..."
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        if self.urlRequest != nil{
            self.webView.loadRequest(self.urlRequest)
        }
        self.webView.delegate = self
    }
}

extension WebViewController: UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.progressView.progress = 0.0
        self.progressView.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.isWebFinishLoading = true
        self.progressView.isHidden = true
        timer.invalidate()
        self.navigationItem.title = self.urlRequest.url?.host

    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressView.isHidden = true
        self.errorLoadingView.isHidden = false
        self.navigationItem.title = "Error Occured"
        errorMessageLabel.text = error.localizedDescription
    }
    
    func timerCallBack(){
        if self.isWebFinishLoading{
            if self.progressView.progress <= 1{
                self.progressView.progress += 0.02
            }
        }else{
            if self.progressView.progress >= 0.95{
                self.progressView.progress = 0.95
            }else{
                self.progressView.progress += 0.01
            }
        }
    }
}
