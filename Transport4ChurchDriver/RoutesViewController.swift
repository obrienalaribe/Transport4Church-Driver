//
//  ViewController.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import UIKit
import MGSwipeTableCell

class RoutesViewController: UITableViewController, MGSwipeTableCellDelegate, ChurchRepoDelegate {
    var routes = [Route]()
    let churchRepo = ChurchRepo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bus Routes"
        self.tableView.separatorStyle = .singleLine
        
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //remove extra cells in footer
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))
        self.tableView.tableFooterView = footer
        
        //remove sticky header
        let dummyViewHeight : CGFloat = 40;
        let dummyView = UIView(frame:CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.tableHeaderView = dummyView;
        self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);

       
        let addBtn =  UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(RoutesViewController.addNewRoute))
        
        addBtn.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = addBtn
        
        let menuBtn = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(RoutesViewController.showMenu))
        menuBtn.tintColor = UIColor.black
        
        navigationItem.leftBarButtonItem = menuBtn
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    
    func showMenu(){
        let menuNavCtrl = UINavigationController(rootViewController:MenuViewController())
        navigationController?.present(menuNavCtrl, animated: true, completion: nil)
    }
    
    /// Notify all rider in this drivers church to make a pickup request
    func actionForRequestingBookings(){
        
        let alertController = UIAlertController (title: "Rider Pickup Notification", message: "Are you sure you would like to notify all riders in your church to place a pickup request ?", preferredStyle: .alert )
        
        let confirmAction = UIAlertAction(title: "Yes, notify everyone", style: .default) { (_) -> Void in
            let driverChurch = ChurchRepo.getCurrentUserChurch()
            CloudFunctions.notifyUserAboutTrip(receiverId: "\(driverChurch!.objectId!):Rider", status: "new", message: "\(driverChurch!.name!) transport team is ready to receive your pickup request")
            
        }

        let ignoreAction = UIAlertAction(title: "No, dont notify", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(ignoreAction)
        
        present(alertController, animated: true, completion: nil)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationHelper.setupNotification()
        
        churchRepo.delegate = self
        refresh()
        
        //Setup toobar
        self.navigationController?.isToolbarHidden = false
        
        let requestBookingsBtn = UIBarButtonItem(image: UIImage(named: "notify_request"), style: .done, target: self, action: #selector(RoutesViewController.actionForRequestingBookings))
        requestBookingsBtn.tintColor = UIColor.black
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items : [UIBarButtonItem] = [space, requestBookingsBtn, space]
        
        self.toolbarItems = items

    }
    
    override  // return the number of cells each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count;
    }

    func refresh(){
        if let driversChurch = ChurchRepo.getCurrentUserChurch() {
            churchRepo.fetchAllRoutes(for: driversChurch)
        }

    }

    func addNewRoute(){

        let viewController = EditRouteViewController()
        viewController.action = "New Route"
        
        self.navigationController?.pushViewController(viewController, animated: true)

    }
    
    // return cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = MGSwipeTableCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.delegate = self;

        cell.textLabel?.text = routes[indexPath.row].name
        cell.imageView?.layer.cornerRadius = 40
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        //set route and index for each cell
        cell.layer.setValue(self.routes[indexPath.row], forKey: "route")
        cell.layer.setValue(indexPath, forKey: "index")
        
        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: " Notify riders", icon: UIImage(named:"notify"), backgroundColor: UIColor(red:0.03, green:0.79, blue:0.49, alpha:1.0), callback: { (cell) -> Bool in
            self.notifyRiders()
            return true; //autohide
        })]
        
        cell.leftSwipeSettings.transition = MGSwipeTransition.rotate3D

        
        if indexPath.row != routes.count-1 {
            
            //configure right buttons
            
            cell.rightButtons = [  MGSwipeButton(title: "Delete", backgroundColor: UIColor.red, callback: { (cell) -> Bool in
                
                self.deleteRoute(route: cell?.layer.value(forKey: "route") as! Route, indexPath: cell?.layer.value(forKey: "index") as! IndexPath)
                return true;
            })
                , MGSwipeButton(title: "Edit", backgroundColor: UIColor.lightGray, callback: { (cell) -> Bool in
                    self.editRoute()
                    return true; //autohide
                })
            ]
            cell.rightSwipeSettings.transition = MGSwipeTransition.rotate3D

        }
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let requestViewController = DriverRequestListController(route: routes[indexPath.row])
            
        self.navigationController?.pushViewController(requestViewController, animated: true)
    }
    
    func didFinishFetchingRoutes(routes: [Route]){
        // The number of routes has been updated
        
        self.routes = routes
        //create default route for requests without a route
        if let driversChurch = ChurchRepo.getCurrentUserChurch() {
            let unknownRoute = Route()
            unknownRoute.name = "Requests without a postcode route"
            unknownRoute.church = driversChurch
            unknownRoute.postcodes = ChurchRepo.getPostcodesWithoutRoutes()            
            self.routes.append(unknownRoute)
        }
       
        self.tableView.reloadData()
    
    }
    
    func didDeleteRoute(){
        refresh()
    }
    
    
    // MARK: Cell Actions
    
    func notifyRiders(){
         print("perform a query and get all riders under this route with a booking")
    }
    
    func deleteRoute(route: Route, indexPath: IndexPath) {
        if routes.last != route {
            //YOU NEED TO ADD THIS ROUTE POSTCODE BACK TO UNCOVERED POSTCODE CACHE
            churchRepo.delete(route: route)
            routes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
    }
    
    func editRoute(){
        print("edit route")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isToolbarHidden = true
     
    }
    
}

