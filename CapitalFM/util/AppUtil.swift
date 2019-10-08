//
//  AppUtil.swift
//  CapitalFM
//
//  Created by mac on 23/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import Foundation
import UIKit

class AppUtil {
    
    func showAlert(title:String, msg:String)
    {
        let alert = UIAlertController(title:title,message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default){
            UIAlertAction in
        }
        
        alert.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func isValidEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
        
    }
}
