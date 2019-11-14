//
//  AppUtil.swift
//  CapitalFM
//
//  Created by mac on 23/09/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

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
    
    public static var Manager: Alamofire.SessionManager = {
        
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            
            "devportal:8443": .disableEvaluation
        ]
        
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
        return manager
    }()

    
//    func bypassURLAuthentication() {
//        let manager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
//        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
//            var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
//            var credential: NSURLCredential?
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                disposition = NSURLSessionAuthChallengeDisposition.UseCredential
//                credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
//            } else {
//                if challenge.previousFailureCount > 0 {
//                    disposition = .CancelAuthenticationChallenge
//                } else {
//                    credential = manager.session.configuration.URLCredentialStorage?.defaultCredentialForProtectionSpace(challenge.protectionSpace)
//                    if credential != nil {
//                        disposition = .UseCredential
//                    }
//                }
//            }
//            return (disposition, credential)
//        }
//    }
}
