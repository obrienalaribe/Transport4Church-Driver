//
//  DriverTripViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 14/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import BRYXBanner
import GoogleMaps

class DriverTripViewController: UIViewController {
    
    var mapView : GMSMapView!

    var currentTrip : Trip?
    var driverLocation : CLLocation!
    
    var driverMockTimer : Timer!

    init(trip: Trip){
        self.currentTrip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height ))
        mapView.mapType = kGMSTypeTerrain
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        view.addSubview(mapView)
        
        title = currentTrip?.rider.user["name"] as! String
   
        let closeTripBtn =  UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(DriverTripViewController.closeActiveTrip))
        
        closeTripBtn.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = closeTripBtn
        
        let callRiderBtn =  UIBarButtonItem(image: UIImage(named: "plain_phone"), style: .plain, target: self, action: #selector(DriverTripViewController.callRider))
        
        callRiderBtn.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = callRiderBtn

    }
    
    func closeActiveTrip(){
        let alertController = UIAlertController (title: "Close Active Trip", message: "Please select an action you would like to take", preferredStyle: .alert )
        
        let completeTripAction = UIAlertAction(title: "Complete pickup", style: .default) { (_) -> Void in
            self.currentTrip?.status = TripStatus.COMPLETED
            self.currentTrip?.saveEventually()
            self.navigationController?.setViewControllers([DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout())], animated: true)
            
        }
        
        let cancelTripAction = UIAlertAction(title: "Cancel pickup", style: .default) { (_) -> Void in
            self.currentTrip?.status = TripStatus.CANCELLED
            self.currentTrip?.saveEventually()
            self.navigationController?.setViewControllers([DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout())], animated: true)
            
            let userId = self.currentTrip?.rider.user.objectId!
            
            SocketIOManager.sharedInstance.sendTripStatusUpdate(toUser: userId!, status: "cancel")
            
            CloudFunctions.notifyUserAboutTrip(receiverId: userId!, status: "cancel", message: "Driver cancelled Trip")
        }
        
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: nil)
        
        
        alertController.addAction(completeTripAction)
        alertController.addAction(cancelTripAction)
        alertController.addAction(continueAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func callRider(){
        let riderPhone = currentTrip?.rider.user["contact"] as! String
        if let url = URL(string: "tel://\(riderPhone)") {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setDriverLocationOnMap()
        
        let riderPosition = CLLocationCoordinate2D(latitude: (currentTrip?.rider.location.latitude)!, longitude: (currentTrip?.rider.location.longitude)!)
        
        let riderLocation = GMSMarker(position: riderPosition)
        
        if let rider = currentTrip?.rider  {
            riderLocation.snippet = "\(rider.addressDic["street"]!) \(rider.addressDic["postcode"]!)"

            riderLocation.title = rider.user["name"] as! String
        }
        
        riderLocation.isFlat = true
        
        riderLocation.icon = UIImage(named: "user")!.withRenderingMode(.alwaysTemplate)
        riderLocation.map = mapView
        

        let driverCoordinates = CLLocationCoordinate2D(latitude: (driverLocation?.coordinate.latitude)!, longitude: (driverLocation?.coordinate.longitude)!)
        let bounds = GMSCoordinateBounds(coordinate: driverCoordinates, coordinate: riderLocation.position)
        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))!
        self.mapView.camera = camera
 
        mapView.settings.myLocationButton = false

        driverMockTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.sendDriverLocation), userInfo: nil, repeats: true)
        
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("stopping location sending socket ...")
        
        driverMockTimer.invalidate()
        
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
            
            mapView.camera = GMSCameraPosition.camera(withLatitude: driverLatitude, longitude: driverLongitude, zoom: 14.0)

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //start timer to emit driver location
        
    }
    
    
    func sendDriverLocation(_ timer: Timer){
        let padLat : Double = (driverLocation.coordinate.latitude) - 0.0001
        let padLong : Double = (driverLocation.coordinate.longitude)  + 0.0001
        
        driverLocation = CLLocation(latitude: padLat, longitude: padLong)
        
        let riderLoc = CLLocation(latitude: self.currentTrip!.rider.location.latitude, longitude: self.currentTrip!.rider.location.longitude)
        
        let distanceInMeters = riderLoc.distance(from: driverLocation)
        let distanceInMiles = distanceInMeters/1609.344
        let distanceString = String(format: "%.1f miles away from you", distanceInMiles)
        
        //send driver location through socket
        SocketIOManager.sharedInstance.sendDriverLocation(driverLocation, to: self.currentTrip!.rider.user.objectId!) {
            print("location sent sucessefully ")
        }
        
    }
    
    
   
}
