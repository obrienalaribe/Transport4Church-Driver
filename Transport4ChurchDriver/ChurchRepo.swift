//
//  ChurchRepo.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Parse



class ChurchRepo {
    
    static var churchNames = [String]()
        
    func fetchNearbyChurches() {
        let query = PFQuery(className: Church.parseClassName())
        print("Fetching churches ...")
        query.findObjectsInBackground { (results, error) in
            if let churches = results as? [Church] {
                for church in churches {
                    ChurchRepo.churchNames.append(church.name!)
                }
            }
        }
    }
    
    func fetchAll(){
        
    }
}
