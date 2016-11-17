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
            ParseMutableClientConfiguration.applicationId = "myAppId"
            ParseMutableClientConfiguration.clientKey = "myMasterKey"
            ParseMutableClientConfiguration.server = "https://insta231.herokuapp.com/parse"
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
