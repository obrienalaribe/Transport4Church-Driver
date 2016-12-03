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
    func didDeleteRoute()
}

class ChurchRepo {
    
    var delegate : ChurchRepoDelegate!
    
    //TODO: Need to create an ordered Set of names to avoid duplicates in records
    static var churchNames = Set<String>()
    static var churchCacheById = Dictionary<String, Church>()
    static var churchCacheByName = Dictionary<String, Church>()
    
    static var postcodesCoveredByChurch = Set<String>()
    
    func fetchNearbyChurchesIfNeeded() {
        if (ChurchRepo.churchNames.isEmpty && ChurchRepo.churchCacheById.isEmpty) {
            let query = PFQuery(className: Church.parseClassName())
            query.findObjectsInBackground { (results, error) in
                if let churches = results as? [Church] {
                    for church in churches {
                        ChurchRepo.churchNames.insert(church.name!)
                        ChurchRepo.churchCacheById[church.objectId!] = church
                        ChurchRepo.churchCacheByName[church.name!] = church
                    }
                    print("Finished caching churches \(ChurchRepo.churchCacheById.count)")

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
                print("Successfully fetched \(objects?.count) routes.")
                
                for object in objects! {
                    let route = object as! Route
                    churchRoutes.append(route)
                    //Cache all church postcodes
                    for postcode in route.postcodes! {
                        ChurchRepo.postcodesCoveredByChurch.insert(postcode)
                    }
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
                print("Cache does not have user church so return current user church")
                return churchObject
            }
        }
        return nil
    }
    
    static func getPostcodesWithoutRoutes() -> Array<String> {
        var setOfAllPostcodes = Set(Helper.parsePostcodePrefix(postcodes:RouteRepo.leedsPostcodes))
        let setOfCoveredPostcodes = ChurchRepo.postcodesCoveredByChurch
        
        let setOfUncoveredPostcodes = setOfAllPostcodes.symmetricDifference(setOfCoveredPostcodes)
        
//        print("set of all postcodes: \(setOfAllPostcodes)")
//        print("covered by church: \(ChurchRepo.postcodesCoveredByChurch)")
//        print("uncovered postcodes: \(setOfUncoveredPostcodes)")

        return (Array(setOfUncoveredPostcodes))
    }
    
    
    func delete(route: Route) {
        route.deleteInBackground { (success, error) in
            if error == nil {
                self.delegate.didDeleteRoute()
            }
        }
    }
    
}
