//
//  LaunchVC.swift
//  CapitalFM
//
//  Created by mac on 13/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit

class LaunchVC: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.MyTheme.primaryColor
     
        btnSignIn.backgroundColor = UIColor.MyTheme.accentColor
        
        let btn = FBLoginButton(frame: CGRect(x: 137, y: 100, width: 100, height: 50), permissions: [.publicProfile])
        self.view.addSubview(btn)
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        <#code#>
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //logout
    }
}
