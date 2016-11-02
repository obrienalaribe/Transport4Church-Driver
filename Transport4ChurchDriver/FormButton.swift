//
//  FormButton.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Foundation
import UIKit

class FormButton: UIButton {
    init(title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.setTitle(title, for: UIControlState())
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.backgroundColor = BrandColours.primary.color
        self.tintColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum BrandColours {
    case primary
    
    fileprivate static let associatedValues = [
        primary: (color: UIColor(red:0.03, green:0.79, blue:0.49, alpha:1.0), value: "primary")
    ]
    
    var color: UIColor {
        return BrandColours.associatedValues[self]!.color
    }
    
    var value: String {
        return BrandColours.associatedValues[self]!.value;
    }
    
}
