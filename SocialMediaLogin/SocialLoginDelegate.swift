//
//  SocialLoginDelegate.swift
//  CircleIT
//
//  Created by MaBook Pro on 10/10/18.
//  Copyright © 2018 Zencode. All rights reserved.
//

import Foundation
import UIKit

protocol SocialLoginDelegate:class
{
    func recievedUserInfo(userDetails:UserInfo)
    func errorRecieved(error:APIError)
}
