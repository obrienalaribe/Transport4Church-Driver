//
//  ChurchRepo.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Parse

protocol ChurchRepoDelegate {
    func didFinishFetchingRoutes(routes: [Route])
}

class ChurchRepo {
    
    var delegate : ChurchRepoDelegate!
    
    static var churchNames = [String]()
    static var churchCacheById = Dictionary<String, Church>()
    static var churchCacheByName = Dictionary<String, Church>()
    
    func fetchNearbyChurchesIfNeeded() {
        if (ChurchRepo.churchNames.isEmpty && ChurchRepo.churchCacheById.isEmpty) {
            let query = PFQuery(className: Church.parseClassName())
            query.findObjectsInBackground { (results, error) in
                if let churches = results as? [Church] {
                    print("Caching churches ...")
                    for church in churches {
                        ChurchRepo.churchNames.append(church.name!)
                        ChurchRepo.churchCacheById[church.objectId!] = church
                        ChurchRepo.churchCacheByName[church.name!] = church
                    }
                }
            }
            
        }else{
            print("No need to update church cache")
        }
        
        
    }
    
    func fetchAllRoutes(for driversChurch: Church) {
        let query = PFQuery(className: Route.parseClassName())
        query.whereKey("church", equalTo: driversChurch)
       
        query.includeKey("church")
        query.limit = 50
       
        var churchRoutes = [Route]()
        
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully refreshed \(objects?.count) object.")
                
                for  object in objects! {
                    let route = object as! Route
                    churchRoutes.append(route)
                }
                self.delegate.didFinishFetchingRoutes(routes: churchRoutes )

            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
        
    }
    

    static func getCurrentUserChurch() -> Church? {
        if let churchObject = PFUser.current()?["Church"] as? Church {
            if let church = ChurchRepo.churchCacheById[ churchObject.objectId!] {
                return church
            }else{
                print("Cache does not have user church")
                print(churchObject)
                return churchObject
            }
        }
        return nil
    }
    
}
