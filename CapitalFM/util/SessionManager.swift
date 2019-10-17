//
//  SessionManager.swift
//  CapitalFM
//
//  Created by mac on 17/10/2019.
//  Copyright © 2019 Smart Applications. All rights reserved.
//

import Foundation

class SessionManager {
    let prefs = UserDefaults.standard
    
    let KEY_API_TOKEN = "api_token"
    let KEY_SOCIAL_TOKEN = "social_token"
    let KEY_SOCIAL_TYPE = "social_type"
    
    func setApiToken(token:String){
        prefs.set(token, forKey: KEY_API_TOKEN)
    }
    
    func getApiToken() -> String {
        if let token = prefs.string(forKey: KEY_API_TOKEN){
            return token
        } else{
            return ""
        }
    }
    
    func setSocialToken(token:String){
        prefs.set(token, forKey: KEY_SOCIAL_TOKEN)
    }
    
    func getSocialToken() -> String {
        if let token = prefs.string(forKey: KEY_SOCIAL_TOKEN){
            return token
        } else{
            return ""
        }
    }
    
    func setSocialType(type:String){
        prefs.set(type, forKey: KEY_SOCIAL_TYPE)
    }
    
    func getSocialType() -> String {
        if let type = prefs.string(forKey: KEY_SOCIAL_TYPE){
            return type
        } else{
            return ""
        }
    }
}
