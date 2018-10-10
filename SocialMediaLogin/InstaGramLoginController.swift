//
//  InstaGramLoginController.swift
//  CircleIT
//
//  Created by CSS on 10/10/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import Foundation
import SwiftInstagram

class InstaGramLoginController {
    
    weak var delegate:SocialLoginDelegate?
    init() {
        
    }
    
    public func makeLogin() {
        instagramLogin()
    }
    
    private func instagramLogin()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let navigation = appDelegate.window?.rootViewController as? UINavigationController else {
            return
        }
        
        let api = Instagram.shared
        api.login(from: navigation, withScopes: [.basic,.publicContent], success: {
            self.getInstagramProfile()
        }) { (error) in
            self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:error.localizedDescription)))
        }
    }
    private func getInstagramProfile()  {
        Instagram.shared.user("self", success: { (user) in
            let userDetails: UserInfo=UserInfo(firstName: user.username, lastName: user.fullName, dob: "", email: "", fullName: user.fullName, gender: "", accesstoken: Instagram.shared.retrieveAccessToken() ?? "")
            self.delegate?.recievedUserInfo(userDetails: userDetails)
        }, failure: { (error) in
            self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:error.localizedDescription)))
        })
    }
    
}
