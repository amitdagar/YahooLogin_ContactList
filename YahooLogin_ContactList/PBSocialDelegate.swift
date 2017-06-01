//
//  PBSocialDelegate.swift
//  PBSocial
//
//  Created by Peerbits Solution on 30/01/17.
//  Copyright © 2017 Peerbits Solution. All rights reserved.
//

import Foundation

@objc protocol PBSocialDelegate:class
{    
    //MARK: Yahoo
    @objc optional func getYahooContacts(userData : [AnyHashable: Any])
    
    
}

var pbSocialDelegate : PBSocialDelegate!
