//
//  EditProfileViewController.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Eureka
import Parse
import ImageRow

class EditProfileViewController : FormViewController {
    
    fileprivate var userRepo : UserRepo = UserRepo()
    fileprivate var profile : Profile?
    fileprivate var userChurch : Church?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Profile"
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 25
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            row.cell.height = {
                return 60
            }
        }
        
        if let church = ChurchRepo.getCurrentUserChurch() {
            self.userChurch = church
        }
        
        form
            //    <<< ImageRow("Picture"){
            //      $0.title = "Select Profile Picture"
            
            //    }.cellSetup({ (cell, row) in
            //      cell.imageView?.image = UIImage(named: "user")
            //    cell.accessoryView = UIImageView(image: UIImage(named:"user"))
            // })
            
            +++ Section("Please fill in your details")
            <<< TextRow("Firstname"){ row in
                row.title = "Firstname"
                row.placeholder = "i.e Emma"
                row.value = userRepo.extractUserField("firstname")
                
            }
            
            <<< TextRow("Surname"){ row in
                row.title = "Surname"
                row.placeholder = "i.e Smith"
                row.value = userRepo.extractUserField("surname")
            }
            
            <<< ActionSheetRow<String>("Gender") {
                $0.title = "Gender"
                $0.selectorTitle = "Select Gender"
                $0.options = ["Male","Female", "Other"]
                $0.value = userRepo.extractUserField("gender")
            }
            
            +++ Section()
            <<< PushRow<String>("Church") {
                $0.title = "Church"
                $0.selectorTitle = "Nearby Churches"
                $0.options = Array(ChurchRepo.churchNames)
                $0.value = userChurch?.name
            }
            
            +++ Section("Number Driver will to contact you on")
            <<< PhoneRow("Contact"){ row in
                row.title = "Contact"
                row.placeholder = ""
                row.value = userRepo.extractUserField("contact")
                
            }
            
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.callback({
                        let button = FormButton(title: "Update")
                        button.addTarget(self, action: #selector(EditProfileViewController.handleFormSubmission(_:)), for: .touchUpInside)
                        return button
                    }))
                    header.height = { 50  }
                    return header
                }()
        }
        
        
    }
    
    func handleFormSubmission(_ sender: UIButton!){
        
        let valuesDictionary = form.values()
        
        
        if let firstname = valuesDictionary["Firstname"] as? String, let surname = valuesDictionary["Surname"] as? String, let gender = valuesDictionary["Gender"] as? String, let contact = valuesDictionary["Contact"] as? String, let church = valuesDictionary["Church"] as? String {
            
            let chosenChurch = ChurchRepo.churchCacheByName[church]
            
            profile = Profile(image: valuesDictionary["Picture"] as? UIImage, firstname: firstname.trim(), surname: surname.trim(), gender: gender.trim(), contact: contact.trim(), church: chosenChurch! )
            
            userRepo.updateProfile(profile!, listener: self)
            
            
        }else{
            Helper.showErrorMessage(title: "Incomplete Fields", subtitle: "Please complete all fields")
        }
        
        
    }
    
    
    /// This lifecycle method will notify all listeners that this profile has been updated before exiting
    override func viewWillDisappear(_ animated: Bool) {
        
        if let userProfile = profile {
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationNamespace.profileUpdated), object: self, userInfo: ["profile":userProfile])
        }
        
        
    }
    
    
    
}

