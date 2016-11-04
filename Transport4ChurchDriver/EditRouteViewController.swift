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
        
        form +++ Section("")
            <<< TextRow("Route"){
                $0.title = "Route name"
                $0.placeholder = "i.e University entrance"
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
        
        print(ChurchRepo.getCurrentUserChurch() )
        
        let route = Route()
        
        if let routeName = valuesDictionary["Route"] as? String, let church = ChurchRepo.getCurrentUserChurch() {
            route.name = routeName
            route.church = church
            
            route.saveInBackground(block: { (success, error) in
                self.navigationController?.popViewController(animated: true)
                Helper.showSuccessMessage(title: "Success", subtitle: "Route \(routeName) was created successfully")
            })
        }
        
    }
    
}
