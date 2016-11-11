//
//  SocketIOManager.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 28/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import CoreLocation

import UIKit
import SocketIO



open class SocketIOManager: NSObject {
    let userRepo = UserRepo()
    open static let sharedInstance = SocketIOManager()
    let socket = SocketIOClient(socketURL: URL(string:"https://t4cserver.herokuapp.com")!)

    //This prevents others from using the default '()' initializer for this class.
    fileprivate override init() {
//        socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
    }
    
    func establishConnection() {
        print("Establishing socket connection ... ")
        addHandlers()
        socket.connect()
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.6 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            //wait for socket to connect first before connnecting user
            if let currentUser = self.userRepo.getCurrentUser() {
                self.socket.emit("connectUser", currentUser.objectId!)
            }
        })
    }
    
    func closeConnection() {
        print("Disconnecting socket connection ... ")
        socket.disconnect()
    }    
    
    func addHandlers() -> Void {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            print("User connected to socket server successfully ... \(dataArray)")
        }
       
    }
    
    func sendDriverLocation(_ location: CLLocation, to userID: String, completionHandler: () -> Void) {
        let dataDictionary = ["userID": userID, "lat": location.coordinate.latitude, "long" : location.coordinate.longitude] as [String : Any]
        socket.emit("driverChangedLocation", dataDictionary)
        completionHandler()
    }
    
}
