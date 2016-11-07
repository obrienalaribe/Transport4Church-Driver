//
//  RouteNotificationViewController.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 07/11/2016.
//
//

import UIKit

class RouteNotificationController: UITableViewController {

    let notificationActions = [
        "Notify all riders who haven't booked their pickup request to do so on time",
        "Notify riders on this route that you are starting your journey"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Rider Notifications"
        self.tableView.separatorStyle = .singleLine
        
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
        //remove extra cells in footer
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))
        self.tableView.tableFooterView = footer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationActions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = notificationActions[indexPath.row]
        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let alertController = UIAlertController (title: "Confirm Action", message: "Are you sure you want to send this notification?", preferredStyle: .alert )
        
        let confirmAction = UIAlertAction(title: "Yes, Notify", style: .default) { (_) -> Void in
            print("Performing your wish for action: \(self.notificationActions[indexPath.row])")
        }
        
        let cancelAction = UIAlertAction(title: "No, don't notify", style: .default, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

}
