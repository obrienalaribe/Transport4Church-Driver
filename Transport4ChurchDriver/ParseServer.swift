//
//  ParseServer.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Foundation

import Parse

class ParseServer {
    init(){
        registerSubClasses()
        configureServer()
    }
    
    func registerSubClasses(){
        Rider.registerSubclass()
        Trip.registerSubclass()
        Route.registerSubclass()
        Church.registerSubclass()
        
    }
    
    func configureServer(){
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "a5dee5f93e5dce98effcfb4aa30bf5f1"
            ParseMutableClientConfiguration.clientKey = "bb054a15cab720e6b3ef4ca890ec1335"
            ParseMutableClientConfiguration.server = "https://transportforchurch.herokuapp.com/parse"
            //            ParseMutableClientConfiguration.server = "http://localhost:1337/parse"
            
        })
        
        Parse.initialize(with: parseConfiguration)
//        initializeChurches()
//                PFUser.logOut()
    }
    

    func initializeChurches(){
        let churchNames = ["EFA RCCG Leeds", "Power Connections Leeds", "Leeds Chinese Church"]
        
        for name in churchNames {
            let church = Church()
            church.name = name
            church.saveInBackground()
        }
    }
    
    
}
