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

       
    }
    
    
    func showMenu(){
        let menuNavCtrl = UINavigationController(rootViewController:MenuViewController())
        navigationController?.present(menuNavCtrl, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let churchRepo = ChurchRepo()
        churchRepo.delegate = self
        
        if let driversChurch = ChurchRepo.getCurrentUserChurch() {
            churchRepo.fetchAllRoutes(for: driversChurch)
        }

    }
    
    override  // return the number of cells each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count;
    }
    

    let paths = [IndexPath(row:11, section:0)]
    

    func addNewRoute(){
//        routes.insert("test", at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)

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
        
        //configure left buttons

        cell.leftButtons = [MGSwipeButton(title: " Notify riders", icon: UIImage(named:"notify"), backgroundColor: UIColor(red:0.03, green:0.79, blue:0.49, alpha:1.0), callback: { (cell) -> Bool in
            print("doing it bitches")
            return true; //autohide
        })]
        
        cell.leftSwipeSettings.transition = MGSwipeTransition.rotate3D
        
//        configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: UIColor.red)
            ,MGSwipeButton(title: "Edit",backgroundColor: UIColor.lightGray)]
        cell.rightSwipeSettings.transition = MGSwipeTransition.rotate3D
//
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let requestViewController = DriverRequestListController(collectionViewLayout: UICollectionViewFlowLayout())
        
        requestViewController.route = routes[indexPath.row]
        
        self.navigationController?.pushViewController(requestViewController, animated: true)
    }
    
    func didFinishFetchingRoutes(routes: [Route]){
        // The number of routes has been updated
        
        print("self.routes.count != routes.count = \(self.routes.count) \(routes.count )")
        if self.routes.count != routes.count {
            self.routes = routes
            self.tableView.reloadData()
        }
        
    }
    
}

