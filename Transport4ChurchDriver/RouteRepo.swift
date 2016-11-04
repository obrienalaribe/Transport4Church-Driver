//
//  RouteRepo.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Parse

class RouteRepo {
    
    func fetchAllPickupRequests(_ view : DriverRequestListController, tripStatus: TripStatus){
        
        if let driversChurch = ChurchRepo.getCurrentUserChurch() {
            let today = Date()
            let cal = Calendar(identifier: .gregorian)
            let startOfToday = cal.startOfDay(for: today)
            let tomorrow = Calendar.current
                .date(byAdding: .day, value: 1, to: today)
            let startOfTmrw = cal.startOfDay(for: tomorrow!)
            
            let query = PFQuery(className:"Trip")
            query.whereKey("destination", equalTo: driversChurch)
            query.whereKey("status", equalTo: tripStatus.rawValue)
            query.whereKey("pickupTime", greaterThanOrEqualTo: startOfToday)
            query.whereKey("pickupTime", lessThanOrEqualTo: startOfTmrw)
            query.includeKey("Rider")
            query.includeKey("User")
            query.addAscendingOrder("pickupTime")
            query.limit = 100
            
            query.findObjectsInBackground {
                (objects: [PFObject]?, error: Error?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully refreshed \(objects?.count) object.")
                    pickupRequests = objects as? [Trip]
                    view.collectionView?.reloadData()
                    
                } else {
                    // Log details of the failure
                    print("Error: \(error!)")
                }
            }
            
        }
        

        }
        
       
}
