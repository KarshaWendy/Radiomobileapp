//
//  LoginVC.swift
//  CapitalFM
//
//  Created by mac on 13/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginVC: UIViewController {

    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var viewFB: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Login"
        
        btnSignIn.backgroundColor = UIColor.MyTheme.primaryColor
        
        viewFB.backgroundColor = UIColor.MyTheme.fbColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
