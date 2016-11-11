//
//  EditRouteController.swift
//  Transport4ChurchDriver
//
//  Created by Obrien Alaribe on 02/11/2016.
//
//

import Eureka

class EditRouteViewController: FormViewController {
    
    var action : String? {
        didSet {
            title = action
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Enter a name for this route")
            <<< TextRow("Route"){
                $0.title = "Route name"
                $0.placeholder = "i.e University entrance"
            }
           
            +++ Section("Choose all postcodes for this route")
            <<< MultipleSelectorRow<String>("Postcodes") {
                $0.title = "Postcodes"
                $0.selectorTitle = "Choose postcodes for this route"
                $0.options = RouteRepo.leedsPostcodes
                $0.value = []   // initially selected
            }
            
            +++ Section() { section in
                section.header = {
                    var header = HeaderFooterView<UIButton>(.callback({
                        let button = FormButton(title: "Submit")
                        button.addTarget(self, action: #selector(AuthViewController.handleFormSubmission(_:)), for: .touchUpInside)
                        return button
                    }))
                    header.height = { 50 }
                    return header
                }()
        }

    }
    
    func handleFormSubmission(_ sender: UIButton!){
        let valuesDictionary = form.values()
        var postcodePrefix = [String]()
        if let selectedPostcodes = valuesDictionary["Postcodes"] {
            postcodePrefix = (Helper.parsePostcodePrefix(postcodes: Array(selectedPostcodes as! Set)))
            
        }
        
        let route = Route()
        
        if let routeName = valuesDictionary["Route"] as? String, let church = ChurchRepo.getCurrentUserChurch() {
            route.name = routeName.trim()
            route.church = church
            route.postcodes = postcodePrefix
            
            route.saveInBackground(block: { (success, error) in
                self.navigationController?.popViewController(animated: true)
                Helper.showSuccessMessage(title: "Success", subtitle: "Route \(routeName) was created successfully")
            })
        }
        
    }
    
}
