//
//  MenuActions.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 25/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Foundation
import UIKit

class MenuActions {
//    "itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8"
    
 
    static func openScheme(_ hook: String){
        let facebookPageUrl = URL(string: hook)
        if UIApplication.shared.canOpenURL(facebookPageUrl!)
        {
            UIApplication.shared.openURL(facebookPageUrl!)
        }else{
            print("cannont open")
        }

    }
}
