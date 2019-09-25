//
//  SignUpVC.swift
//  CapitalFM
//
//  Created by mac on 18/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Sign Up"
        
        btnSignUp.backgroundColor = UIColor.MyTheme.accentColor
        // Do any additional setup after loading the view.
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
