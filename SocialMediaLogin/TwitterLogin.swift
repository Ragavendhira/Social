//
//  TwitterLogin.swift
//  CircleIT
//
//  Created by MaBook Pro on 10/10/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
class TwitterLogin {
    
    weak var delegate:SocialLoginDelegate?
    
    init() {
        
    }
    
    public func makeLogin() {
        twitterLogin()
    }
    
    private func twitterLogin()
    {
        var userDetails:UserInfo=UserInfo(firstName: "", lastName: "", dob: "", email: "", fullName: "", gender: "", accesstoken: "")
        TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                userDetails.firstName=(session?.userName)!
                userDetails.accesstoken=(session?.authToken)!
                self.getMailIDFromTwitter(userDetail: userDetails)
                
            } else {
                self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:(error?.localizedDescription)!)))
            }
        })
     
        
    }
   private func getMailIDFromTwitter(userDetail:UserInfo)
    {
        var userDetails=userDetail
        let client = TWTRAPIClient.withCurrentUser()
        client.loadUser(withID: TWTRAPIClient.withCurrentUser().userID!, completion: { (user, errorTweer) in
            if errorTweer==nil
            {
                userDetails.firstName = (user?.name)!
                client.requestEmail { email, error in
                    if (email != nil) {
                        userDetails.email=email!
                        self.delegate?.recievedUserInfo(userDetails: userDetails)
                    } else
                    {
                        self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage: "unabel to get email from twitter please allow our app to get it")))
                        print("Unable get email from twitter")
                    }
                }
            }
        })
        
    }
}
