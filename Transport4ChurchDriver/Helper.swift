//
//  Helper.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Foundation

//
//  Commons.swift
//  Transport4Church
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import BRYXBanner

class Helper {
    
    static func convertDateToString(_ date : Date) -> String{
        // format the NSDate to a NSString
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "cccc, MMM d, hh:mm aa"
        let dateString = dateFormat.string(from: date)
        return dateString
    }
    
    static func convertStringToDate (_ date : String) -> Date{
        // format the NSDate to a NSString
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var dateFromString = Date()
        dateFromString = dateFormatter.date(from: date)!
        return dateFromString
    }
    
    static func resizeImage(_ image:UIImage, toTheSize size:CGSize) -> UIImage{
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect( x: 0, y: 0, width: width, height: height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    
    
    static func userHasGoogleMapsInstalled() -> Bool{
        let googleMapsAppURL = URL(string: "comgooglemaps-x-callback://")!
        if UIApplication.shared.canOpenURL(googleMapsAppURL) {
            return true
        } else {
            return false
        }
    }
    
    static func showErrorMessage(title: String?, subtitle: String){
        let banner = Banner(title: title, subtitle: subtitle, image: UIImage(named: "close"), backgroundColor: UIColor.white)
        banner.textColor = UIColor.red
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    static func showSuccessMessage(title: String?, subtitle: String?){
        let banner = Banner(title: title, subtitle: subtitle, image: UIImage(named: "tick"), backgroundColor: UIColor.white)
        banner.textColor = BrandColours.primary.color
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    static func showInfoMessage(title: String?, subtitle: String?){
        let banner = Banner(title: title, subtitle: subtitle, image: UIImage(named: "info"), backgroundColor: UIColor.white)
        banner.textColor = UIColor(red:0.00, green:0.41, blue:1.00, alpha:1.0)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    static func parsePostcodePrefix(postcodes: [String]) -> [String] {
        return postcodes.map { (postcode) -> String in
            return "\(postcode.components(separatedBy: "-")[0].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))"
        }
    }
    
}
