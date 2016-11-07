//
//  RouteRepo.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Parse

protocol RouteRepoDelegate {
    func didFinishFetchingTripRequests(requests: [Trip])
}

class RouteRepo {
    
    var delegate : RouteRepoDelegate!
    
    func fetchAllPickupRequests(_ view : DriverRequestListController, tripStatus: TripStatus, route: Route){
        
        if let driversChurch = ChurchRepo.getCurrentUserChurch() {
            let today = Date()
            let cal = Calendar(identifier: .gregorian)
            let startOfToday = cal.startOfDay(for: today)
            
            let yesterday = Calendar.current
                .date(byAdding: .day, value: -1, to: today)
            let startOfYesterday = cal.startOfDay(for: yesterday!)

            let tmrw = Calendar.current
                .date(byAdding: .day, value: 1, to: today)
            let startOfTmrw = cal.startOfDay(for: tmrw!)

            let query = PFQuery(className:Trip.parseClassName())
            query.whereKey("destination", equalTo: driversChurch)
            query.whereKey("status", equalTo: tripStatus.rawValue)
            query.whereKey("pickupTime", greaterThanOrEqualTo: startOfYesterday)
            query.whereKey("pickupTime", lessThanOrEqualTo: startOfTmrw)
            query.includeKey("Rider")
            query.addAscendingOrder("pickupTime")
            query.limit = 100
            
            query.findObjectsInBackground {
                (objects: [PFObject]?, error: Error?) -> Void in
                
                if error == nil {
                    let trips = objects as? [Trip]
                    
                    let pickupRequests = trips?.filter({ (trip) -> Bool in
                        if let rider =  trip["Rider"] as? Rider {
                            let routePostcodes = route.postcodes
                            let riderPostcodePrefix = rider.addressDic["postcode"]!.components(separatedBy: " ")[0]
                        
                            return routePostcodes!.contains(riderPostcodePrefix)
                        }else{
                            return false
                        }
                        
                    })
                    
                    print("Successfully fetched \(objects?.count) requests but returned filtered list of \(pickupRequests?.count).")

                    
                    self.delegate.didFinishFetchingTripRequests(requests: pickupRequests!)
                                
                } else {
                    // Log details of the failure
                    print("Error: \(error!)")
                }
            }
            
        }
        

        }
    
    
    static let leedsPostcodes = [
        "LS1 - Leeds city centre",
        "LS2 - City centre, Woodhouse",
        "LS3 - Woodhouse",
        "LS4 - Burley, Kirkstall, Kirkstall Valley",
        "LS5 - Hawksworth, Kirkstall",
        "LS6 - Beckett Park, Headingley, Hyde Park, Meanwood, Woodhouse",
        "LS7 - Chapel Allerton, Chapeltown, Little London, Meanwood, Potternewton, Scott Hall, Sheepscar",
        "LS8 - Fearnville, Gipton, Gledhow, Harehills, Oakwood, Roundhay",
        "LS9 - Burmantofts, Cross Green, East End Park, Gipton, Harehills, Osmondthorpe, Richmond Hill",
        "LS10 - Belle Isle, Hunslet, Middleton, Stourton",
        "LS11 - Beeston, Beeston Hill, Cottingley, Holbeck",
        "LS12 - Armley, Farnley, New Farnley, Wortley",
        "LS13 - Bramley, Rodley, Swinnow",
        "LS14 - Killingbeck, Seacroft, Scarcroft, Swarcliffe, Thorner, Whinmoor",
        "LS15 - Austhorpe, Barwick-in-Elmet, Colton, Cross Gates",
        "LS16 - Adel, Holt Park, Moor Grange, Tinshill, Weetwood, West Park",
        "LS17 - Alwoodley, Moor Allerton, Moortown, Shadwell, Weardley, Wike",
        "LS18 - Horsforth",
        "LS19 - Rawdon, Yeadon",
        "LS20 - Guiseley",
        "LS21 - Arthington, Otley, Pool",
        "LS22 - Collingham, Linton, Wetherby",
        "LS23 - Boston Spa, Bramham, Clifford, Thorp Arch, Walton",
        "LS24 - Saxton, Stutton, Ulleskelf, Church Fenton, Tadcaster, Toulston",
        "LS25 - Aberford, Ferry Fryston, Garforth, Hillam, Kippax, Ledsham, Micklefield, Monk Fryston, Sherburn-in-Elmet",
        "LS26 - Great Preston, Methley, Mickletown, Oulton, Rothwell, Swillington, Woodlesford",
        "LS27 - Churwell, Gildersome, Morley",
        "LS28 - Calverley, Farsley, Pudsey, Stanningley",
        "LS29 - Addingham, Ben Rhydding, Burley in Wharfedale, Ilkley, Menston"
    ]
    
}
