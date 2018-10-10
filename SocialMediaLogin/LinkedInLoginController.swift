//
//  LinkedInLoginController.swift
//  CircleIT
//
//  Created by CSS on 10/10/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import UIKit
import LinkedinSwift

class LinkedInLoginController {
    
   weak var delegate:SocialLoginDelegate?
    var clientId: String
    var clientSecret: String
    var redirectURI: String
    let PERMISSIONS = ["r_basicprofile","r_emailaddress"]
    let LINKEDIN_PROFILE_URL = "https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address)?format=json"
    
    init() {
        self.clientId = ""
        self.clientSecret = ""
        self.redirectURI = ""
    }
    convenience init(clinetId: String, clientSecret: String, redirectURI: String) {
        self.init()
        self.clientId = clinetId
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
    }
    
    public func makeLogin() {
        linkedInLogin()
    }
    
    
   private func linkedInLogin()  {
        if LinkedinSwiftHelper.isLinkedinAppInstalled() {
            let client = LinkedinNativeClient(permissions: PERMISSIONS)
            client?.logout()
            client?.authorizeSuccess({ (success) in
                self.getLinkedProfile(client, token: success)
            }, error: { (error) in
                self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:error.localizedDescription)))
            }, cancel: {
                self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:"Canceled")))
            })
            
        }else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let webClient = LinkedinOAuthWebClient(redirectURL: self.redirectURI, clientId: self.clientId, clientSecret: self.clientSecret, state: "1e", permissions: PERMISSIONS, present: appDelegate.window?.rootViewController!)
            webClient?.authorizeSuccess({ (success) in
                self.getLinkedProfile(webClient, token: success)
            }, error: { (error) in
                self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:error.localizedDescription)))
            }, cancel: {
                self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:"Canceled")))
            })
        }
    }
    
   private func getLinkedProfile(_ client: LinkedinClient?, token: LSLinkedinToken)  {
        guard let client = client else {
            return
        }
        client.requestURL(LINKEDIN_PROFILE_URL, requestType: LinkedinSwiftRequestGet, token: token, success: { (success) in
            if let response = success.jsonObject {
                let userDetails: UserInfo=UserInfo(firstName: response["firstName"] as? String ?? "" , lastName: response["lastName"] as? String ?? "", dob: response[""] as? String ?? "", email: response["emailAddress"] as? String ?? "", fullName: response[""] as? String ?? "", gender: "", accesstoken: token.accessToken)
                self.delegate?.recievedUserInfo(userDetails: userDetails)
            }
        }) { (error) in
            self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:error.localizedDescription)))
        }
        
    }

}
