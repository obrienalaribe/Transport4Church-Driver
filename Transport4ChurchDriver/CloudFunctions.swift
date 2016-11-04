//
//  CloudFunctions.swift
//  Transport4Church
//
//  Created by mac on 10/9/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import Parse

open class CloudFunctions {

    //VERBOSE_PARSE_SERVER_PUSH_ADAPTER = 1
    //VERBOSE = 1
    
    //        let cloudParams : [AnyHashable:Any?] = [:]
    static func notifyUserAboutTrip(receiverId: String, status:String, message: String){
        
        PFCloud.callFunction(inBackground: "notifyUserAboutTrip", withParameters:  ["receiverId" : receiverId, "status": status, "message": message], block: {
            (result: Any?, error: Error?) -> Void in
            if error != nil {
                print(error)
            }else{
                print(result)
            }
            
        })

    }

}
