//
//  DriverRequestListController.swift
//  Transport4Church
//
//  Created by mac on 8/11/16.
//  Copyright © 2016 rccg. All rights reserved.
//

import UIKit
import Parse
import BRYXBanner
import CoreLocation

let cellId = "cellId"
let EFA_Coord = CLLocationCoordinate2DMake(53.804489, -1.578694)

//TODO: Make all requests come from Parse

class DriverRequestListController: UICollectionViewController, UICollectionViewDelegateFlowLayout, RouteRepoDelegate {

    var routeRepo = RouteRepo()
    var route: Route?
    var pickupRequestsByRoute : [Trip]?
    var riders = [Rider]()


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(collectionViewLayout: UICollectionViewLayout) {
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    convenience init(route: Route) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.route = route
        navigationItem.title = self.route!.name
        routeRepo.delegate = self
    }

    
    let items = ["New", "Completed", "Cancelled"]
    let status = [TripStatus.REQUESTED, TripStatus.COMPLETED, TripStatus.CANCELLED]
    var tripStatusToggle : UISegmentedControl!
    
    override func loadView() {
        super.loadView()
        tripStatusToggle = UISegmentedControl(items: items)
        tripStatusToggle.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.main.bounds
        tripStatusToggle.frame = CGRect(x: frame.minX + 10, y: frame.minY + 70,
                                    width: frame.width - 20, height: frame.height*0.1)
        
        // Style the Segmented Control
        tripStatusToggle.layer.cornerRadius = 5.0  // Don't let background bleed
        tripStatusToggle.backgroundColor = UIColor.darkGray
        tripStatusToggle.tintColor = UIColor.white
        
        // Add target action method
        tripStatusToggle.addTarget(self, action: #selector(DriverRequestListController.changeView(_:)), for: .valueChanged)
        
        // Add this custom Segmented Control to our view
        self.view.addSubview(tripStatusToggle)
        

    }
    
    func changeView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            refresh()
        case 2:
            refresh()
        default:
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumLineSpacing = 10
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(PickupRequestCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        
        let mapViewBtn = UIBarButtonItem(image: UIImage(named: "rider_mapview"), style: .plain, target: self, action: #selector(DriverRequestListController.showMapView))
        mapViewBtn.tintColor = UIColor.black

        self.navigationItem.rightBarButtonItem = mapViewBtn

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    

    func refresh(){
        if let route = self.route {
            routeRepo.fetchAllPickupRequests(self, tripStatus: status[tripStatusToggle.selectedSegmentIndex], route: route)

        }
        
    }
    
    func showMapView(){
        self.navigationController?.pushViewController(RiderMapClusterController(route: self.route!, riders: riders), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
        self.downloadGoogleMapsIfNeeded()
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let requests = pickupRequestsByRoute {
            return requests.count
        }
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PickupRequestCell
        
        cell.acceptBtn.layer.setValue((indexPath as NSIndexPath).row, forKey: "index")
        cell.acceptBtn.addTarget(self, action: #selector(DriverRequestListController.showDriverTripMode(_:)), for: .touchUpInside)

        cell.trip = pickupRequestsByRoute?[(indexPath as NSIndexPath).row]
 
        if tripStatusToggle.selectedSegmentIndex != 0 {
            cell.tripDisabledMode = true
        }else{
            cell.tripDisabledMode = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(tripStatusToggle.frame.height + 17, 0, 0, 0)
    }
  
    
    func showDriverTripMode(_ sender: UIButton){
        
        print("showing trip view")
        
        let row = sender.layer.value(forKey: "index") as! Int
        let trip : Trip = pickupRequestsByRoute![row]
        
        trip.status = TripStatus.ACCEPTED
        trip.driver = PFUser.current()!
        trip.saveEventually()
        
        //TODO: Pass in the notification message from here not on the server
        CloudFunctions.notifyUserAboutTrip(receiverId: trip.rider.user.objectId!, status: TripStatus.ACCEPTED.rawValue, message: "The church bus is on its way now")
        self.navigationController?.setViewControllers([DriverTripViewController(trip: trip)], animated: true)

    }
  
    
    
    func downloadGoogleMapsIfNeeded(){
        if Helper.userHasGoogleMapsInstalled() == false {
            //Prompt to download Google maps
            let alertController = UIAlertController (title: "Download Google Maps", message: "Please download Google Maps to help you get navigation to a rider's location", preferredStyle: .alert)
            
            let downloadAction = UIAlertAction(title: "Download", style: .default) { (_) -> Void in
                let googleMapsDownloadURL = URL(string: "itms://itunes.apple.com/us/app/google-maps-navigation-transit/id585027354")
                if UIApplication.shared.canOpenURL(googleMapsDownloadURL!) {
                    UIApplication.shared.openURL(googleMapsDownloadURL!)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Ignore", style: .default, handler: nil)
            
            alertController.addAction(cancelAction)
            alertController.addAction(downloadAction)
            
            self.navigationController?.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    // MARK- RouteRepoDelegate
    func didFinishFetchingTripRequests(requests: [Trip]) {
        self.pickupRequestsByRoute = requests
        self.collectionView?.reloadData()
        
        for request in self.pickupRequestsByRoute! {
            if request.status == TripStatus.REQUESTED {
                self.riders.append(request.rider)
            }
        }
        
        
    }
    
}

class PickupRequestCell : BaseCollectionCell {
    
    var tripDisabledMode : Bool? {
        didSet {
            if tripDisabledMode == true {
                acceptBtn.isUserInteractionEnabled = false
                acceptBtn.setTitleColor(UIColor(red:0.89, green:0.83, blue:0.83, alpha:1.0), for: UIControlState())
                acceptBtn.setImage(UIImage(named: "ok-disabled"), for: UIControlState())

            }else{
                acceptBtn.isUserInteractionEnabled = true
                acceptBtn.setTitleColor(UIColor.darkGray, for: UIControlState())
                acceptBtn.setImage(UIImage(named: "Ok-48"), for: UIControlState())
            }
        }
    }
    
    var trip : Trip? {
        didSet {
            
            trip?.rider.user.fetchInBackground(block: { (user, error) in
                let firstname = ((user)!["firstname"] as? String)!
                let surname = ((user)!["surname"] as? String)!
                self.nameLabel.text = "\(firstname) \(surname)"
                self.callButton.layer.setValue((user)!["contact"], forKey: "contact")
                
                if let extraRiders = self.trip?.extraRiders {
                    if extraRiders > 0 {
                        self.nameLabel.text = self.nameLabel.text!.trunc(by: 13 ) + " + " + String(extraRiders)
                    }
                }
              
            })
            
            print(trip?.rider.addressDic)
            
            if let street = trip?.rider.addressDic["street"], let city = trip?.rider.addressDic["city"],  let postcode = trip?.rider.addressDic["postcode"]{
                self.addressLabel.text = "\(street)\n\(city)\n\(postcode)"

            }

            let dateString : String = Helper.convertDateToString((trip?.pickupTime)!)
            
            let dateArr = (dateString).characters.split{$0 == ","}.map(String.init)
            
            self.timeLabel.text = dateArr.last
            
            
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        imageView.image = UIImage(named: "user_male")?.imageWithInsets(10)

        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "--------------"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    let callButton: UIButton = {
        let button = UIButton()
        button.setTitle("Call", for: UIControlState())
        button.setTitleColor(UIColor.darkGray, for: UIControlState())
        let image = UIImage(named: "Phone-48")
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
        button.setImage(image, for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let acceptBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Accept", for: UIControlState())
        button.setTitleColor(UIColor.darkGray, for: UIControlState())
        let image = UIImage(named: "Ok-48")
        button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 18)
        button.setImage(image, for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        button.contentHorizontalAlignment = .left
        
        return button
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(profileImageView)

        addConstraintsWithFormat("H:|-12-[v0(80)]", views: profileImageView)
        addConstraintsWithFormat("V:[v0(80)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
       
        setupDetailView()
        setupActionButtons()

    }
    
    fileprivate func setupDetailView() {
        let detailView = UIView()
        addSubview(detailView)
        
        addConstraintsWithFormat("H:|-105-[v0]|", views: detailView)
        addConstraintsWithFormat("V:|-7-[v0(90)]", views: detailView)
//        addConstraint(NSLayoutConstraint(item: detailView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        detailView.addSubview(nameLabel)
        detailView.addSubview(timeLabel)
        detailView.addSubview(addressLabel)

        detailView.addConstraintsWithFormat("H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        
        detailView.addConstraintsWithFormat("V:|[v0][v1(60)]", views: nameLabel, addressLabel)
        
        detailView.addConstraintsWithFormat("H:|[v0]|", views: addressLabel)
        
        detailView.addConstraintsWithFormat("V:|[v0(24)]", views: timeLabel)

        //place divider under detail view
        
        addSubview(dividerLineView)

        addConstraintsWithFormat("H:|-100-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]-48-|", views: dividerLineView)
        
    }

    
    fileprivate func setupActionButtons(){
        let actionButtonContainer = UIView()
        addSubview(actionButtonContainer)
        
        addConstraintsWithFormat("H:|-105-[v0]|", views: actionButtonContainer)
        addConstraintsWithFormat("V:[v0(40)]|", views: actionButtonContainer)

        callButton.addTarget(self, action: #selector(PickupRequestCell.handleCallEvent), for: .touchUpInside)
        actionButtonContainer.addSubview(callButton)

        actionButtonContainer.addSubview(acceptBtn)

        actionButtonContainer.addConstraintsWithFormat("H:|[v0][v1(v0)]|", views: callButton, acceptBtn)
        actionButtonContainer.addConstraintsWithFormat("V:|[v0]|", views: callButton)
        actionButtonContainer.addConstraintsWithFormat("V:|[v0]|", views: acceptBtn)
 
    }
    
    
    func handleCallEvent(){
        
        if let riderPhone = callButton.layer.value(forKey: "contact") {
            if let url = URL(string: "tel://\(riderPhone)") {
                UIApplication.shared.openURL(url)
            }
            print("calling \(riderPhone)")
        }
        
        print(callButton.layer.value(forKey: "contact"))
        
    }
    
    func handleCompleteEvent(_ sender: UIButton!){
        let parent = self.superview as! UICollectionView

//        let indexPath = parent.indexPathForCell(self)
//        pickupRequests?.removeAtIndex(indexPath!.row)
//        parent.deleteItemsAtIndexPaths([indexPath!])
//        parent.reloadData()
       
    }

}



class BaseCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    }
}
