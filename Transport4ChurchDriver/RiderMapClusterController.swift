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
            
        }else{
            //mock driver location on simulator
            let driverLatitude = EFA_Coord.latitude
            let driverLongitude = EFA_Coord.longitude
            
            driverLocation = CLLocation(latitude: driverLatitude, longitude: driverLongitude)
            
            mapView.camera = GMSCameraPosition.camera(withLatitude: driverLatitude, longitude: driverLongitude, zoom: 9.0)
            
            let mockCoords = [CLLocationCoordinate2DMake(53.79099916072296,-1.552514210343361), CLLocationCoordinate2DMake(53.74539341153303,-1.534240320324898 ), CLLocationCoordinate2DMake(53.78989318758644, -1.549911126494408),
                CLLocationCoordinate2DMake(53.80620828430762, -1.578214801847935),
                CLLocationCoordinate2DMake(53.79014472773473, -1.607189700007439),
                CLLocationCoordinate2DMake(53.80443745419082, -1.578116901218891),
                CLLocationCoordinate2DMake(53.80362923070406, 1.577232778072357),
                CLLocationCoordinate2DMake(53.79022771584644, -1.546331718564034),
                CLLocationCoordinate2DMake(53.80023856143028, -1.563368104398251),
                CLLocationCoordinate2DMake(53.79723239018069, -1.557342521846294),
                CLLocationCoordinate2DMake(53.79107125394805, -1.552353948354721),
                CLLocationCoordinate2DMake(53.80278891519445, -1.576994061470032),
                CLLocationCoordinate2DMake(51.44382403056893, -0.9470625221729279),
                CLLocationCoordinate2DMake(53.79774924281458, -1.565506830811501),
                CLLocationCoordinate2DMake(53.79208193246318, -1.559161394834518),
                CLLocationCoordinate2DMake(53.76078991691048, -1.532976664602757),

                ]
            
            var bounds = GMSCoordinateBounds()

            for coord in mockCoords {
                var marker = GMSMarker()
                marker.icon = UIImage(named: "user")!.withRenderingMode(.alwaysTemplate)
                marker.position = coord
                marker.isFlat = true
                marker.title = "\(coord.latitude)"
                marker.snippet = "snipp"
                marker.map = mapView

                bounds = bounds.includingCoordinate(marker.position)
                
            }
            
            let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
            mapView.animate(with: update)
        }
    }

}
