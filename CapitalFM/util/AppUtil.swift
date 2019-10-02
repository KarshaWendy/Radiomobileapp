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
}