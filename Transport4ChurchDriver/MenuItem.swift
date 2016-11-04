//
//  MenuItem.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 25/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//


enum MenuItem : CustomStringConvertible {
    case profile
    case rate
    case like
    case copyright
    case terms
    case privacy
    case faq
    case contact
    
    var description : String {
        switch self {
            // Use Internationalization, as appropriate.
            case .profile : return "Profile"
            case .rate: return "Rate us in the App Store"
            case .like: return "Like us on Facebook"
            case .copyright: return "Copyright"
            case .terms: return "Terms & Conditions"
            case .privacy: return "Privacy Policy"
            case .faq: return "FAQ"
            case .contact: return "Contact Us"
        }
    }
    
}
