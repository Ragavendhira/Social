//
//  GoogleLogin.swift
//  CircleIT
//
//  Created by MaBook Pro on 10/10/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import Alamofire

class GoogleLoginController: NSObject {
    
    weak var delegate:SocialLoginDelegate?
    
    override init() {
        
    }
    
    public func makeLogin() {
        self.makeLogin()
    }
    
   private func googleLogin()
    {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes=["https://www.googleapis.com/auth/userinfo.email","https://www.googleapis.com/auth/userinfo.profile","https://www.googleapis.com/auth/plus.login"," https://www.googleapis.com/auth/plus.me"]
        GIDSignIn.sharedInstance().signIn()
        
    }

}

extension GoogleLoginController: GIDSignInDelegate,GIDSignInUIDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if let error = error {
            self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:error.localizedDescription)))
        } else {
            
            let gplusapi = "https://www.googleapis.com/plus/v1/people/\(user.userID!)?key=AIzaSyDIFABc24DViYOyyff2GMq86lhN_W9peXY"
            let url = NSURL(string: gplusapi)
            let  header = ["Content-Type":"application/json; charset=utf-8"]
            Alamofire.request(gplusapi, method: .get, parameters:nil, encoding: JSONEncoding.default, headers:header).responseData(completionHandler: { response -> Void in
                if response.result.isSuccess
                {
                    do {
                        let userData:NSDictionary = (try JSONSerialization.jsonObject(with: response.data!, options:[]) as? NSDictionary)!
                        var userDetails:UserInfo=UserInfo(firstName: "", lastName: "", dob: "", email: "", fullName: "", gender: "", accesstoken: "")
                        userDetails.firstName=GIDSignIn.sharedInstance().currentUser.profile.name
                        userDetails.email=GIDSignIn.sharedInstance().currentUser.profile.email
                        userDetails.accesstoken=GIDSignIn.sharedInstance().currentUser.authentication.idToken
                        if let error:NSDictionary = userData.object(forKey: "error") as? NSDictionary
                        {

                            self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:(error.object(forKey: "message") as? String)!)))
                            return
                        }
                        if let userGender = userData.object(forKey: "gender") as? String
                        {
                            
                        }
                        if let userAge = userData.object(forKey: "birthday") as? String {
                            let ageComponents = userAge.components(separatedBy: "-")
                            let dateDOB = Calendar.current.date(from: DateComponents(year:
                                Int(ageComponents[0]), month: Int(ageComponents[1]), day:
                                Int(ageComponents[2])))!
                        }
                        
                    } catch {
                        self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:error.localizedDescription)))
                    }
                }
                else
                {

                    self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:error.localizedDescription)))
                    
                }
            })
            
        }
    }
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        self.delegate?.errorRecieved(error:APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:(error?.localizedDescription)!)))
        
    }
    private func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: Error!)
    {
        self.delegate?.errorRecieved(error:APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:(error?.localizedDescription)!)))
    }
    
}
