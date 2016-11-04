//
//  Rider.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

class Rider : PFObject, PFSubclassing  {
    private static var __once: () = {
            registerSubclass()
        }()

    var address : Address!
    @NSManaged var user : PFUser
    @NSManaged var location : PFGeoPoint
    @NSManaged var addressDic : Dictionary<String, String>

    override init(){
        super.init()
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken: Int = 0;
        }
        _ = Rider.__once
    }
    
    static func parseClassName() -> String {
        return "Rider"
    }

}
