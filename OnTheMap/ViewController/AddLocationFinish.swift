//
//  PostingView.swift
//  OnTheMap
//
//  Created by Ahmed Alsamani on 03/02/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationFinishViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var user = StudentLocation(mapString : API.shared.mapString ?? "")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        createAnnotation()
        
    }
    func createAnnotation(){
        let annotation = MKPointAnnotation()
        
        annotation.title = API.shared.mapString
        annotation.subtitle = API.shared.mediaURL
        
        annotation.coordinate = CLLocationCoordinate2DMake(API.shared.latitude!, API.shared.longitude!)
        self.mapView.addAnnotation(annotation)
        
        
        //zooming to location
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(API.shared.latitude!, API.shared.longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func FinishButton(_ sender: Any) {
        user.firstName = API.shared.firstName
        user.lastName =  API.shared.lastName
        user.latitude = API.shared.latitude
        user.longitude = API.shared.longitude
        user.mapString = API.shared.mapString
        user.mediaURL = API.shared.mediaURL
        user.uniqueKey = API.shared.key
        
        if API.shared.objectId == "" {
            PostNewLocation()
        }else {
            UpdateLocation()
        }
    }
    
    func PostNewLocation(){
        API.shared.postLocation(user) { (Rest)  in
            DispatchQueue.main.async {
                guard (Rest != nil) else {
                    guard API.shared.exError == "" else {
                        Alert1Action (VC:self,title: "Error !", message: API.shared.exError ?? "unknown error")
                        return
                    }
                    Alert1Action (VC:self,title: "Error Post Location!", message: "")
                    return
                }
                let Post =  Rest! as StudentLocation
                API.shared.objectId = Post.objectId
                self.BackToRoot()
            }
        }
    }
    
    func UpdateLocation(){
        API.shared.updateLocation(user) { (Rest)  in
            DispatchQueue.main.async {
                guard (Rest != nil) else {
                    guard API.shared.exError == "" else {
                        Alert1Action (VC:self,title: "Error !", message: API.shared.exError ?? "unknown error")
                        return
                    }
                    Alert1Action (VC:self,title: "Error update Location!", message: "")
                    return
                }
                self.BackToRoot()
            }
        }
    }
    
    func BackToRoot() {
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = false
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
        
    }
}
