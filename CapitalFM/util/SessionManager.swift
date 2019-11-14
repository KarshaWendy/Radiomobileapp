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
    let KEY_SOCIAL_PLATFORM = "social_platform"
    let KEY_LOGGED_IN = "logged_in"
    let KEY_NAME = "name"
    let KEY_EMAIL = "email"
    let KEY_FACEBOOK = "facebook"
    let KEY_TWITTER = "twitter"
    let KEY_SERVER = "server"
    
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
    
    func setSocialPlatform(platform:String){
        prefs.set(platform, forKey: KEY_SOCIAL_PLATFORM)
    }
    
    func getSocialPlatform() -> String {
        if let platform = prefs.string(forKey: KEY_SOCIAL_PLATFORM){
            return platform
        } else{
            return ""
        }
    }
    
    func setName(name:String){
        prefs.set(name, forKey: KEY_NAME)
    }
    
    func getName() -> String {
        if let name = prefs.string(forKey: KEY_NAME){
            return name
        } else{
            return ""
        }
    }
    
    func setEmail(email:String){
        prefs.set(email, forKey: KEY_EMAIL)
    }
    
    func getEmail() -> String {
        if let email = prefs.string(forKey: KEY_EMAIL){
            return email
        } else{
            return ""
        }
    }
    
    func setIsLoggedIn(value:Bool){
        prefs.set(value, forKey: KEY_LOGGED_IN)
    }
    
    func isLoggedIn() -> Bool {
        return prefs.bool(forKey: KEY_LOGGED_IN)
    }
    
    func setSession(token:String, name:String, email:String, socialPlatform:String) {
        setName(name: name)
        setEmail(email: email)
        
        if socialPlatform == KEY_TWITTER {
            setSocialPlatform(platform: KEY_TWITTER)
            setSocialToken(token: token)
        } else if socialPlatform == KEY_FACEBOOK {
           setSocialPlatform(platform: KEY_FACEBOOK)
            setSocialToken(token: token)
        } else if socialPlatform == KEY_SERVER{
            setSocialPlatform(platform: KEY_SERVER)
            setApiToken(token: token)
        }
        
        setIsLoggedIn(value: true)
    }
    
    func clearSession(){
        setName(name: "")
        setEmail(email: "")
        setSocialPlatform(platform: "")
        setIsLoggedIn(value: false)
    }
    
}
