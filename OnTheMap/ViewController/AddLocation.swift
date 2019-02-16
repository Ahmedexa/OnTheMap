//
//  AddLocation.swift
//  OnTheMap
//
//  Created by Ahmed Alsamani on 06/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var myLocationTextField: UITextField!
    
    @IBOutlet weak var myWebsiteTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var latitude : Double?
    var longitude : Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator.stopAnimating()
        tabBarController?.tabBar.isHidden = true
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func returnBackToRoot() {
        DispatchQueue.main.async {
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func findLocationButton(_ sender: Any) {
        guard let website = myWebsiteTextField.text else {
            return
        }
        if website.range(of:"http://") == nil {
            Alert1Action(VC:self,title: "Not Valid Website!",message: "Should Contains http://")
        }
        else {
            if myLocationTextField.text != "" && myWebsiteTextField.text != "" {
                
                activityIndicator.startAnimating()
                
                let MKRequest = MKLocalSearch.Request()
                MKRequest.naturalLanguageQuery = myLocationTextField.text
                
                let MKSearch = MKLocalSearch(request: MKRequest)
                
                MKSearch.start { (response, error) in
                    
                    if error != nil {
                        self.activityIndicator.stopAnimating()
                        
                        print("Location Error : \(error!.localizedDescription)")
                        Alert1Action(VC:self,title: "Opps!",message:"Location Not Found")
                    }else {
                        self.activityIndicator.stopAnimating()
                        
                        self.latitude = response?.boundingRegion.center.latitude
                        self.longitude = response?.boundingRegion.center.longitude
                        
                        API.shared.latitude = self.latitude
                        API.shared.longitude = self.longitude
                        API.shared.mapString = self.myLocationTextField.text
                        API.shared.mediaURL = self.myWebsiteTextField.text
                        
                        self.performSegue(withIdentifier: "AddLocationFinish", sender: nil)
                    }
                }
            }else {
                DispatchQueue.main.async {
                     Alert1Action(VC:self,title: "Opps!",message: "Enter your Location & your URL")
                }
            }
        }
    }
    
}
