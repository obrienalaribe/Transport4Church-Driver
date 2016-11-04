//
//  MenuViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 19/08/2016.
//  Copyright © 2016 rccg. All rights reserved.
//


import UIKit
import Parse

class MenuViewController: UITableViewController {
    let userRepo = UserRepo()

    fileprivate let userSection: [MenuItem] = [.profile]
    fileprivate let enquirySection: [MenuItem] = [.rate, .like, .copyright, .terms, .privacy, .faq, .contact]
    fileprivate let menuIcons: Dictionary<MenuItem, String> = [.profile : "user_male", .rate : "rate", .like : "like", .copyright : "copyright", .terms: "terms", .privacy: "privacy", .faq : "faq", .contact : "contact"]
    
    fileprivate let sections: NSArray = [" ", " "]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
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

        //add close button
        let closeBtn =  UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(MenuViewController.closeMenu))
        closeBtn.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = closeBtn
        

    }
    
    func closeMenu(){
        navigationController?.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // return the title of sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return sections[section] as? String
    }
    
       // called when the cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            let profileController = ProfileViewController()
            profileController.title = "Edit Profile"
            navigationController?.pushViewController(profileController, animated: true)
            
        } else if (indexPath as NSIndexPath).section == 1 {
            
            switch((indexPath as NSIndexPath).row) {
                case 0:
                    MenuActions.openScheme("itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8")
                    break
                case 1:
                    MenuActions.openScheme("fb://page/?id=1177853545619876")
                    break
                case 2:
                    break
                case 3:
                    break
                case 4:
                    break
                case 5:
                    break
                default:
                    return
                }
            
            print("Value: \(enquirySection[(indexPath as NSIndexPath).row])")
            
        }
    }
    
    // MARK: - Tableview Data Source
    
    override  // return the number of cells each section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userSection.count
        } else if section == 1 {
            return enquirySection.count
        } else {
            return 0
        }
    }
    
    // return cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (indexPath as NSIndexPath).section == 0 {
            cell.textLabel?.text = "\(userSection[(indexPath as NSIndexPath).row])"
            cell.imageView?.image = UIImage(named: menuIcons[userSection[(indexPath as NSIndexPath).row]]!)?.imageWithInsets(10)
            cell.imageView?.layer.cornerRadius = 40
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.backgroundColor = UIColor(white: 0.95, alpha: 1)

        } else if (indexPath as NSIndexPath).section == 1 {
            cell.textLabel?.text = "\(enquirySection[(indexPath as NSIndexPath).row])"
            cell.imageView?.image = UIImage(named: menuIcons[enquirySection[(indexPath as NSIndexPath).row]]!)
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((indexPath as NSIndexPath).section == 0) {
            if ((indexPath as NSIndexPath).row == 0) {
                return 95;
            }
        }
        return 44;
    }
   
  }
