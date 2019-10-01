//
//  LaunchVC.swift
//  CapitalFM
//
//  Created by mac on 13/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
//import FacebookCore
import FacebookLogin
import FBSDKCoreKit
//import FBSDKLoginKit

class LaunchVC: UIViewController, LoginButtonDelegate {

    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnFBLogin: FBLoginButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.MyTheme.primaryColor
     
        btnSignIn.backgroundColor = UIColor.MyTheme.accentColor
        btnFBLogin.permissions = ["public_profile"]
        btnFBLogin.delegate = self
        
        
        
//        let btn = FBLoginButton(frame: CGRect(x: 137, y: 100, width: 100, height: 50), permissions: [.publicProfile, .email])
//        self.view.addSubview(btn)
        
        if let token = AccessToken.current{
            print("signed in")
            print(token)
//            btnFBLogin.isHidden = true
        } else {
            print("signed out")
        }
    }
    
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
        if result!.isCancelled{
            print("is cancelled")
        } else {
            print(result!.token)
            
            if !result!.grantedPermissions.contains("public_profile")
            {
                // show error
                //logout
                return
            }
            
            if !result!.grantedPermissions.contains("email")
            {
                // show error
                //logout
                return
            }
            print("success")
            
            let r = GraphRequest(graphPath: "me", parameters: ["fields":"email, name, first_name, last_name"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)
            
            r.start(completionHandler: { (test, result, error) in
                if(error == nil)
                {
                    print(result)
                }
                else {
                    //show error
                }
            })
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //logout
    }
}
