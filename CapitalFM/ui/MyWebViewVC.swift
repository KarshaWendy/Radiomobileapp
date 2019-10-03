//
//  MyWebViewVC.swift
//  CapitalFM
//
//  Created by mac on 02/10/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class MyWebViewVC: UIViewController, WKUIDelegate {

    var url : URL!
    var webView: WKWebView!
    var loader : MBProgressHUD!
    
    override func loadView() {
        super.loadView()
        
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            loader.hide(animated: true)
        }
    }

}
