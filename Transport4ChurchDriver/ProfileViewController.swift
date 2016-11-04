//
//  ProfileViewController.swift
//  Transport4Church
//
//  Created by Obrien Alaribe on 09/09/2016.
//  Copyright © 2016 rccg. All rights reserved.
//

import Eureka
import Parse

class ProfileViewController : UIViewController {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.5
        imageView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        imageView.image = UIImage(named: "user_male")?.imageWithInsets(20)
        imageView.layer.zPosition = 2
        return imageView
    }()
    
    let profileContent: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        return view
    }()
    
    let editBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit Profile", for: UIControlState())
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = BrandColours.primary.color.cgColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(BrandColours.primary.color, for: UIControlState())
        return btn
    }()
    
    let logoutBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("Logout", for: UIControlState())
        btn.layer.cornerRadius = 5.0;
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.layer.borderWidth = 1.7
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.darkGray, for: UIControlState())
        btn.layer.zPosition = 2
        return btn
    }()
  
    var nameLabel : UILabel!
    var churchLabel : UILabel!
    var roleLabel : UILabel!
    
    var currentUser : PFUser!
    let userRepo = UserRepo()
    
    override func loadView() {
        super.loadView()
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.actOnProfileUpdate(notification:)), name: NSNotification.Name(rawValue: Constants.NotificationNamespace.profileUpdated), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        title = "Profile"
        if let user = PFUser.current() {
            currentUser = user
          
            view.addSubview(profileImageView)
            view.backgroundColor = UIColor(white: 0.97, alpha: 1)
            
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:  -150).isActive = true
            
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(profileContent)
            
            let margins = view.layoutMarginsGuide
            
            profileContent.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
            profileContent.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
            profileContent.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                                             constant: -30.0).isActive = true
            
            profileContent.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                constant: -60.0).isActive = true
            
            profileContent.backgroundColor = UIColor.white
            
            profileContent.translatesAutoresizingMaskIntoConstraints = false
            
            
            let profileContentMargin = profileContent.layoutMarginsGuide
            
            setupLogoutBtn(profileContentMargin)
            setupEditBtn(profileContentMargin)
            setupNameLabel(profileContentMargin)
            setupChurchLabel(profileContentMargin)
            setupRoleLabel(profileContentMargin)
            
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        userRepo.fetchAndSetUsersProfileImage(currentUser, imageView: self.profileImageView)

    }
    
    func setupEditBtn(_ parentMargin : UILayoutGuide){
        profileContent.addSubview(editBtn)
        
        editBtn.topAnchor.constraint(equalTo: profileContent.topAnchor, constant: 40).isActive = true
        
        editBtn.leadingAnchor.constraint(equalTo: parentMargin.leadingAnchor).isActive = true
        
        editBtn.trailingAnchor.constraint(equalTo: parentMargin.trailingAnchor).isActive = true
        
        editBtn.translatesAutoresizingMaskIntoConstraints = false
        
        editBtn.addTarget(self, action: #selector(ProfileViewController.editProfileAction), for: .touchUpInside)
    }
   
    func editProfileAction(){
        self.navigationController?.pushViewController(EditProfileViewController(), animated: true)
    }
    
    func setupNameLabel(_ parentMargin : UILayoutGuide){
        let fullname = "\(userRepo.extractUserField("firstname")) \(userRepo.extractUserField("surname"))"
        nameLabel = createProfileLabel(fullname)
        
        profileContent.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: editBtn.bottomAnchor, constant: 20).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: parentMargin.leadingAnchor).isActive = true
        
        nameLabel.trailingAnchor.constraint(equalTo: parentMargin.trailingAnchor).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupChurchLabel(_ parentMargin : UILayoutGuide){
        if let church = ChurchRepo.getCurrentUserChurch() {
            churchLabel = createProfileLabel("Church: \(church.name!) \n")
        }
        
        churchLabel.numberOfLines = 3
        
        profileContent.addSubview(churchLabel)
        
        churchLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        
        churchLabel.leadingAnchor.constraint(equalTo: parentMargin.leadingAnchor).isActive = true
        
        churchLabel.trailingAnchor.constraint(equalTo: parentMargin.trailingAnchor).isActive = true
        
        churchLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupRoleLabel(_ parentMargin : UILayoutGuide){
        roleLabel = createProfileLabel("Joined as \(userRepo.extractUserField("role")) \n \(Helper.convertDateToString(currentUser.createdAt!))")
        roleLabel.numberOfLines = 2

        profileContent.addSubview(roleLabel)
        
        roleLabel.topAnchor.constraint(equalTo: churchLabel.bottomAnchor, constant: 10).isActive = true
        
        roleLabel.leadingAnchor.constraint(equalTo: parentMargin.leadingAnchor).isActive = true
        
        roleLabel.trailingAnchor.constraint(equalTo: parentMargin.trailingAnchor).isActive = true
        
        roleLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupLogoutBtn(_ parentMargin : UILayoutGuide){
        view.addSubview(logoutBtn)
        
        logoutBtn.topAnchor.constraint(equalTo: profileContent.bottomAnchor, constant: 10).isActive = true
        
        logoutBtn.leadingAnchor.constraint(equalTo: parentMargin.leadingAnchor).isActive = true
        
        logoutBtn.trailingAnchor.constraint(equalTo: parentMargin.trailingAnchor).isActive = true
        
        logoutBtn.translatesAutoresizingMaskIntoConstraints = false
        
        logoutBtn.addTarget(self, action: #selector(ProfileViewController.logout), for: .touchUpInside)
        
    }
    
    /**
     This function is an observer method that listens for when a profile is updated. It is called on EditProfileViewController.willDisapper()
     */
    func actOnProfileUpdate(notification: NSNotification){
        Helper.showSuccessMessage(title: nil, subtitle: "Profile updated successfully")
        
        if let profile = notification.userInfo?["profile"] as? Profile {
            self.nameLabel.text = "\(profile.firstname) \(profile.surname)"
            self.churchLabel.text = "\(profile.church.name!) \n"
            self.roleLabel.text = "Joined as \(userRepo.extractUserField("role")) \n \(Helper.convertDateToString(currentUser.createdAt!))"
            
            userRepo.getCurrentUser()?["firstname"] = profile.firstname
            userRepo.getCurrentUser()?["surname"] = profile.surname

        }
        print("profile view controller received Profile update Notification")
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("profile view stopped observing for profile updates")
    }

    func logout(){
        PFUser.logOut()
        self.navigationController?.setViewControllers([AuthViewController()], animated: true)
    }
    
    fileprivate func createProfileLabel(_ title : String) -> UILabel{
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.darkGray
        label.text = title
        label.textAlignment = .center
        return label
    }
    
 
    
}


