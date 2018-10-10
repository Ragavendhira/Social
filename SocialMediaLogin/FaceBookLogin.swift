//
//  FaceBookLogin.swift
//  CircleIT
//
//  Created by MaBook Pro on 10/10/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
class FaceBooklogin 
{
    var viewController:UIViewController?
    
    init() {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.viewController = appDelegate.window?.rootViewController
    }
    
    weak var delegate:SocialLoginDelegate?
    
    public func makeLogin() {
        facebookLogin()
    }
    
    private func facebookLogin()
    {
        let loginManager = FBSDKLoginManager.init()
        loginManager.loginBehavior = .native
        loginManager.logIn(withReadPermissions: ["email","public_profile","user_friends","user_birthday"], from: viewController!, handler: {result,error in
            if (result?.isCancelled)!
            {
                self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .None, displayMessage:"User cancelled login")))
            }
            else if (result?.declinedPermissions.count)! > 0
            {
                self.delegate?.errorRecieved(error:APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:"Unable to get \(String(describing: result?.declinedPermissions))!")))
            }
            else if error==nil
            {
                self.getFBUserData()
            }
            else
            {
                self.delegate?.errorRecieved(error: APIError(status: false, error: APIError.ErrorDetail(errorCode: 0, errorType: .AlertMessage, displayMessage:(error?.localizedDescription)!)))
            }
        })
    }
    private func getFBUserData()
    {
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, email,first_name,middle_name,last_name, picture.type(large),gender,age_range,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    var userDetails:UserInfo=UserInfo(firstName: "", lastName: "", dob: "", email: "", fullName: "", gender: "", accesstoken: "")
                    if let dictResult = result! as? NSDictionary
                    {
                        if let userID = dictResult.object(forKey: "id") as? String
                        {
                            
                        }
                        if let firstN = dictResult.object(forKey: "first_name") as? String {
                            userDetails.firstName=firstN
                        }
                        if let lastN = dictResult.object(forKey: "last_name") as? String {
                            userDetails.lastName=lastN
                        }
                        if let userMail = dictResult.object(forKey: "email") as? String {
                            userDetails.email=userMail
                        }
                        if let userGender = dictResult.object(forKey: "gender") as? String
                        {
                        }
                        if let userAge = dictResult.object(forKey: "birthday") as? String {
                            //                            let ageComponents = userAge.components(separatedBy: "/")
                            //                            let dateDOB = Calendar.current.date(from: DateComponents(year:
                            //                                Int(ageComponents[2]), month: Int(ageComponents[0]), day:
                            //                                Int(ageComponents[1])))!
                            let inputFormatter = DateFormatter()
                            inputFormatter.dateFormat = "MM/dd/yyyy"
                            let showDate = inputFormatter.date(from: userAge)
                            inputFormatter.dateFormat = "MM-dd-yyyy"
                            let resultString = inputFormatter.string(from: showDate!)
                            userDetails.dob=resultString
                            
                        }
                        userDetails.accesstoken=FBSDKAccessToken.current().tokenString
                        self.delegate?.recievedUserInfo(userDetails: userDetails)
                    }
                    
                }
                else
                {
                    print("FacebbokError:\(String(describing: error?.localizedDescription))")
                }
            })
        }
    }
}
