//
//  UIViewExtension.swift
//  Transport4Church
//
//  Created by mac on 8/7/16.
//  Copyright © 2016 rccg. All rights reserved.
//


//
//  UIViewExtension.swift
//  SLOCO
//
//  Created by mac on 5/24/16.
//  Copyright © 2016 sloco. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithFormat(_ format:String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        
        //push all the views into a dictionary
        for(index, view) in views.enumerated() {
            let key = "v\(index)" //i.e v0, v1
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
}

extension UILabel {
    func flash() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 1.1, //Time duration you want,
            delay: 0.0,
            options: [.autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 0.0 })
    }
}

extension UIImage {
    func imageWithInsets(_ insetDimen: CGFloat) -> UIImage {
        return imageWithInset(UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(_ insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
    
}

extension Date
{
    
    init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        let d = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:d)
    }
}

//Date(dateString:"2014-06-06")

extension String {
    func trunc(by value: Int) -> String {
        if self.characters.count > value {
            let index = self.index(self.startIndex, offsetBy: value)
            return self.substring(to: index) + " ..."
        } else {
            return self
        }
    }
}

