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

class LoginVC: UIViewController {

    @IBOutlet weak var ivBg: UIImageView!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var ViewRegister: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPass: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    var appUtil = AppUtil()
    var email = ""
    var password = ""
    
    //    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = false
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.backgroundColor = UIColor.MyTheme.primaryColor
        btnSignIn.setTitleColor(UIColor.MyTheme.primaryColor, for: .normal)
        ViewRegister.isHidden = true
//        ivBg.tintColor = .darkGray
   
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
    
    func login(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let params = ["": ""]
        let headers = ["": ""]
        Alamofire.request(MyConstants().SOUNDCLOUD_CLIENT_ID, method: .post, parameters: params, encoding: nil, headers: headers)
    }

}
