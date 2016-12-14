//
//  DriverTripViewDelegates.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 14/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

//
//  RiderPickupDelegates.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 15/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import GooglePlaces
import GoogleMaps
import Parse

// MARK: GMSMapViewDelegate

extension DriverTripViewController : GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {

    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
                       
    }
    
    
    func riderDidCancelTrip(){
        let alertController = UIAlertController (title: "Rider cancelled trip", message: "Please choose what action you would like to take", preferredStyle: .alert)
        
        let callRiderAction = UIAlertAction(title: "Call rider", style: .default) { (_) -> Void in
            if let user = self.currentTrip?.rider.user{
                
                if let riderPhoneNum = user["contact"] {
                    if let url = URL(string: "tel://\(riderPhoneNum)") {
                        UIApplication.shared.openURL(url)
                    }
                }
                self.navigationController?.setViewControllers([RoutesViewController(), DriverRequestListController(route: self.route!)], animated: true)
            }
            
        }
        
        let confirmAction = UIAlertAction(title: "Okay", style: .default) { (_) -> Void in
            self.navigationController?.setViewControllers([RoutesViewController(), DriverRequestListController(route: self.route!)], animated: true)
        }
        
        alertController.addAction(callRiderAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
        


    }
    
}


// MARK: CLLocationManagerDelegate

extension DriverTripViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
            print("why did you decline ?")
            
            manager.requestAlwaysAuthorization()
            
        } else if (status == CLAuthorizationStatus.authorizedAlways) {
            // The user accepted authorization
            print("thanks for accepting ")
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if let driverLocation = manager.location {
             let riderLoc = CLLocation(latitude: self.currentTrip!.rider.location.latitude, longitude: self.currentTrip!.rider.location.longitude)
            
            //Keep the rider marker in view while moving
            var visibleRegion : GMSVisibleRegion = self.mapView.projection.visibleRegion()
            let bounds = GMSCoordinateBounds(coordinate: visibleRegion.nearLeft, coordinate: visibleRegion.farRight)
            
            if bounds.contains(riderLoc.coordinate) == false {
                print("you need to update the map view now")
                let camera = mapView.camera(for: bounds, insets: UIEdgeInsets(top: 20, left: 80, bottom: 20, right: 80))!
                self.mapView.camera = camera
                
            }
            
            if currentTrip?.status == TripStatus.ACCEPTED {
                //send driver location through socket
                SocketIOManager.sharedInstance.sendDriverLocation(driverLocation, to: self.currentTrip!.rider.user.objectId!) {
                    print("location sent ")
                }
            }
           
        }
        
    }
    

}
