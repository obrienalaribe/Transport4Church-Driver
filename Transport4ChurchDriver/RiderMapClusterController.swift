//
//  RiderMapClusterController.swift
//  Transport4Church
//
//  Created by mac on 11/2/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import GoogleMaps


class RiderMapClusterController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    var mapView : GMSMapView!
    var driverLocation : CLLocation!
    var route: Route?
    var riders : [Rider]?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(route: Route, riders: [Rider]) {
        self.route = route
        self.riders = riders
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = self.route!.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height ))
        mapView.mapType = kGMSTypeTerrain
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        view.addSubview(mapView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDriverLocationOnMap()

    }

    
    func setDriverLocationOnMap(){
        let manager = CLLocationManager()
        manager.delegate = self
        
        if let location = manager.location {
            let driverLatitude = location.coordinate.latitude
            let driverLongitude = location.coordinate.longitude
            
            driverLocation = CLLocation(latitude: driverLatitude, longitude: driverLongitude)
            
            mapView.camera = GMSCameraPosition.camera(withLatitude: driverLatitude, longitude: driverLongitude, zoom: 14.0)
            
            showRequestCluster()
            
        }else{
            //mock driver location on simulator
            let driverLatitude = EFA_Coord.latitude
            let driverLongitude = EFA_Coord.longitude
            
            driverLocation = CLLocation(latitude: driverLatitude, longitude: driverLongitude)
            
            mapView.camera = GMSCameraPosition.camera(withLatitude: driverLatitude, longitude: driverLongitude, zoom: 9.0)
            
            showRequestCluster()
           
          
        }
    }
    
    func showRequestCluster(){
        
        var bounds = GMSCoordinateBounds()
        
        if let riders = self.riders {
            
            for rider in riders {
                var marker = GMSMarker()
                marker.icon = UIImage(named: "user")!.withRenderingMode(.alwaysTemplate)
                marker.position = CLLocationCoordinate2DMake(rider.location.latitude, rider.location.longitude)
                marker.isFlat = true
                marker.title = "\(rider.user["firstname"]!) \(rider.user["surname"]!)"
                marker.snippet = "Location: \(rider.addressDic["street"]!) \(rider.addressDic["postcode"]!)"
                marker.map = mapView
                
                bounds = bounds.includingCoordinate(marker.position)
                
            }
            

        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView.animate(with: update)
    }

}
