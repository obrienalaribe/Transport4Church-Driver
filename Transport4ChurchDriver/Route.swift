//
//  Route.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Parse

class Route : PFObject, PFSubclassing  {
    private static var __once: () = {
        registerSubclass()
    }()

    @NSManaged var name : String?
    @NSManaged var church : Church?
    @NSManaged var postcodes : [String]?
    
    override init(){
        super.init()
    }
    
    override class func initialize() {
        struct Static {
            static var onceToken: Int = 0;
        }
        _ = Route.__once
    }
    
    static func parseClassName() -> String {
        return "Route"
    }
    
}
