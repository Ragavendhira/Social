//
//  SocialLoginController.swift
//  CircleIT
//
//  Created by CSS on 11/04/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import GoogleSignIn
import Alamofire
import TwitterKit
import SwiftInstagram
import LinkedinSwift



class SocialLoginController:NSObject
{
    var loginType:LoginType = .Facebook
    weak var delegate:SocialLoginDelegate?
    var vcParent:UIViewController
    
    var linkedInClientId: String?
    var linkedInClientSecrect: String?
    var linkedInRedirectURI: String?
    
    init(withType:LoginType,controller:UIViewController, delegate: SocialLoginDelegate? = nil)
    {
        vcParent=controller
        loginType=withType
        super.init()
        switch withType
        {
        case .Facebook:
            let facebook = FaceBooklogin()
            facebook.delegate = delegate
            facebook.makeLogin()
        case .Google:
            let google = GoogleLoginController()
            google.delegate = delegate
            google.makeLogin()
        case .Twitter:
            let twitter = TwitterLogin()
            twitter.delegate = delegate
            twitter.makeLogin()
        case .InstaGram:
            let instaGram = InstaGramLoginController()
            instaGram.delegate = delegate
            instaGram.makeLogin()
            break
        case .LinkedIn:
            guard let uri = Bundle.main.getLinkedInRedirectURI() else {
                fatalError("Please add LinkedIn_REDIRECT_URI for linkedIn in your Info.Plist")
            }
            self.linkedInRedirectURI = uri
            self.linkedInClientId = Bundle.main.getLinkedInClientId()
            self.linkedInClientSecrect = Bundle.main.getLinkedInClentSecret()
           let linkedIn = LinkedInLoginController(clinetId: self.linkedInClientId!, clientSecret: self.linkedInClientSecrect!, redirectURI: self.linkedInRedirectURI!)
            self.delegate = delegate
            linkedIn.delegate = delegate
            linkedIn.makeLogin()
        
            break
        }
    }
    
    convenience init(loginType: LoginType, viewcontroller: UIViewController, clientId: String, clientSecrect: String, redirectURI: String? = nil, delegate: SocialLoginDelegate? = nil) {
        self.init(withType: loginType, controller: viewcontroller)
        switch loginType {
        case .Facebook:
            let facebook = FaceBooklogin()
            facebook.delegate = delegate
            facebook.makeLogin()
            break
        case .Google:
            let google = GoogleLoginController()
            google.delegate = delegate
            google.makeLogin()
            break
        case .Twitter:
            let twitter = TwitterLogin()
            twitter.delegate = delegate
            twitter.makeLogin()
            break
        case .InstaGram:
            let instaGram = InstaGramLoginController()
            instaGram.delegate = delegate
            instaGram.makeLogin()
            break
        case .LinkedIn:
            guard let uri = redirectURI else {
                fatalError("Provide Redirect URI(redirectURI) for linkedIn")
            }
            self.linkedInRedirectURI = uri
            self.linkedInClientId = clientId
            self.linkedInClientSecrect = clientSecrect
            let linkedIn = LinkedInLoginController(clinetId: self.linkedInClientId!, clientSecret: self.linkedInClientSecrect!, redirectURI: self.linkedInRedirectURI!)
            linkedIn.delegate = delegate
            break
        }
    }
}



extension Bundle {
    
    func getInfoDict() -> [String: Any] {
        return self.infoDictionary ?? [:]
    }
    
    func getLinkedInClientId() -> String? {
        return self.infoDictionary?["LinkedIn_CLIENT_ID"] as? String ?? nil
    }
    func getLinkedInClentSecret() -> String? {
        return self.infoDictionary?["LinkedIn_CLIENT_SECRET"] as? String ?? nil
    }
    func getLinkedInRedirectURI() -> String? {
        return self.infoDictionary?["LinkedIn_REDIRECT_URI"] as? String ?? nil
    }
}


