//
//  Church.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Parse

class Church : PFObject, PFSubclassing  {
    private static var __once: () = {
        registerSubclass()
    }()
    
    @NSManaged var name : String?
    @NSManaged var location : PFGeoPoint?

    override init(){
        super.init()
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken: Int = 0;
        }
        _ = Church.__once
    }
    
    static func parseClassName() -> String {
        return "Church"
    }
    

}
