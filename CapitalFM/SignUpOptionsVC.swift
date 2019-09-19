//
//  SignUpOptionsVC.swift
//  CapitalFM
//
//  Created by mac on 13/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignUpOptionsVC: UIViewController, GIDSignInDelegate  {
    
    @IBOutlet weak var btnGoogleSignIn: GIDSignInButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sign Up"
        btnCreate.backgroundColor = UIColor.MyTheme.accentColor
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        
        performSegue(withIdentifier: "segueHome", sender: self)
    }
}
