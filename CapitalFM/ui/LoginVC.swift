//
//  LoginVC.swift
//  CapitalFM
//
//  Created by mac on 13/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import FacebookLogin
import FBSDKCoreKit

class LoginVC: UIViewController, LoginButtonDelegate  {

    @IBOutlet weak var ivBg: UIImageView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var ViewRegister: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfRegEmail: UITextField!
    @IBOutlet weak var tfRegPass: UITextField!
    @IBOutlet weak var tfConfirmPass: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnFBLogin: FBLoginButton!
    
    var appUtil = AppUtil()
    var email = ""
    var password = ""
    var name = ""
    var confirmPass = ""
    
    let fbText = NSAttributedString(string: "LOGIN WITH FACEBOOK")
    
    //    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCustomUI()
        btnFBLogin.delegate = self
   
        if let token = AccessToken.current{
            print("signed in")
            print(token)
            //            btnFBLogin.isHidden = true
        } else {
            print("signed out")
            btnFBLogin.setAttributedTitle(fbText, for: .normal)
        }
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        ViewRegister.isHidden = true
        viewLogin.isHidden = false
        btnSignIn.setTitleColor(UIColor.MyTheme.primaryColor, for: .normal)
        btnSignUp.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        ViewRegister.isHidden = false
        viewLogin.isHidden = true
        btnSignIn.setTitleColor(UIColor.white, for: .normal)
        btnSignUp.setTitleColor(UIColor.MyTheme.primaryColor, for: .normal)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        email = tfEmail.text!
        password = tfPass.text!
        
        if !email.isEmpty && !password.isEmpty {
            if appUtil.isValidEmail(enteredEmail: email){
                login()
            } else {
                appUtil.showAlert(title: "", msg: "Enter a valid email address")
            }
        } else {
            appUtil.showAlert(title: "", msg: "Fill in both fields")
        }
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        email = tfRegEmail.text!
        name = tfName.text!
        password = tfRegPass.text!
        confirmPass = tfConfirmPass.text!
        
        if !email.isEmpty && !name.isEmpty  && !password.isEmpty  && !confirmPass.isEmpty {
            if appUtil.isValidEmail(enteredEmail: email){
                if password == confirmPass {
                    register()
                } else {
                    appUtil.showAlert(title: "", msg: "passwords do not match")
                }
            } else {
                appUtil.showAlert(title: "", msg: "Enter a valid email address")
            }
        } else {
            appUtil.showAlert(title: "", msg: "Fill in all fields")
        }
    }
    
    func login(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = ["": ""]
        let headers = ["": ""]
        //        Alamofire.request(MyConstants().SOUNDCLOUD_CLIENT_ID, method: .post, parameters: params, encoding: nil, headers: headers)
    }

    func register(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = ["": ""]
        let headers = ["": ""]
        //        Alamofire.request(MyConstants().SOUNDCLOUD_CLIENT_ID, method: .post, parameters: params, encoding: nil, headers: headers)
    }
    
    func setUpCustomUI(){
        tfEmail.layer.cornerRadius = tfEmail.frame.size.height/2
        tfEmail.clipsToBounds = true
        tfPass.layer.cornerRadius = tfPass.frame.size.height/2
        tfPass.clipsToBounds = true
        tfRegEmail.layer.cornerRadius = tfRegEmail.frame.size.height/2
        tfRegEmail.clipsToBounds = true
        tfRegPass.layer.cornerRadius = tfRegPass.frame.size.height/2
        tfRegPass.clipsToBounds = true
        tfName.layer.cornerRadius = tfName.frame.size.height/2
        tfName.clipsToBounds = true
        tfConfirmPass.layer.cornerRadius = tfConfirmPass.frame.size.height/2
        tfConfirmPass.clipsToBounds = true
        
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height/2
        btnRegister.layer.cornerRadius = btnRegister.frame.size.height/2
        btnLogin.backgroundColor = UIColor.MyTheme.primaryColor
        btnRegister.backgroundColor = UIColor.MyTheme.primaryColor
        btnSignIn.setTitleColor(UIColor.MyTheme.primaryColor, for: .normal)
        ViewRegister.isHidden = true
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        if error != nil {
            print(error?.localizedDescription)
        }
        
        if result!.isCancelled{
            print("is cancelled")
        } else {
//            print(result!.token)
            
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
        btnFBLogin.setAttributedTitle(fbText, for: .normal)
    }
}
