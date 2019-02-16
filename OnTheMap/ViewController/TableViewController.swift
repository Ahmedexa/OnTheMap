//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Ahmed Alsamani on 12/01/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
  
    
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        getStudentsLocations()
    }
    
    func getStudentsLocations(){
        StudentsLocations.shared.studentLocation.removeAll()
        self.userTableView.reloadData()
        activityIndicator.startAnimating()
        
        API.shared.getStudentsLocations { (locations) in
            DispatchQueue.main.async {
                guard (locations != nil) else {
                    self.activityIndicator.stopAnimating()
                    guard API.shared.exError == "" else {
                        Alert1Action (VC:self,title: "Error !", message: API.shared.exError ?? "unknown error")
                        return
                    }
                    Alert1Action (VC:self,title: "Error loading locations!", message: "")
                    return
                }
                
                let locations2 =  locations! as StudentLocationResult
                StudentsLocations.shared.studentLocation =  locations2.results!
                print(StudentsLocations.shared.studentLocation.count)
                
                self.activityIndicator.stopAnimating()
                self.userTableView.reloadData()
            }
        }
        
        
    }
    
    @IBAction func addLocation(_ sender: Any) {
        AddLocation(self)
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        getStudentsLocations()
    }
    
    @IBAction func logout(_ sender: Any) {
        Logout(self)
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocations.shared.studentLocation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! StudentViewCell
        cell.fillCell(usersData: StudentsLocations.shared.studentLocation[indexPath.row] )
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = StudentsLocations.shared.studentLocation[indexPath.row].mediaURL,
            let url = URL(string: urlString){
            
            if url.absoluteString.contains("http://") || url.absoluteString.contains("https://") {
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            }else {
                DispatchQueue.main.async {
                    Alert1Action(VC:self,title: "Cannot Open Website!", message: "Not Valid Website")
                }
            }
        }
    }
    
    
}

func AddLocation(_ VC: UIViewController) {
    API.shared.getUserInfo() { (user)  in
        DispatchQueue.main.async {
            guard (user != nil) else {
                guard API.shared.exError == "" else {
                    Alert1Action (VC:VC,title: "Error !", message: API.shared.exError ?? "unknown error")
                    return
                }
                Alert1Action(VC:VC,title: "Error loading locations!", message: "")
                return
            }
            if (user?.results?.count == 0) {
                VC.performSegue(withIdentifier: "AddLocation", sender: nil)
            }else{
                Alert2Action(VC:VC,title: "You have student location!", message: "Would you Like to change it?")
            }
        }
    }
}

func Logout(_ VC: UIViewController) {
    API.shared.logout() { (session)  in
        DispatchQueue.main.async {
            guard (session != nil) else {
                guard API.shared.exError == "" else {
                    Alert1Action (VC:VC,title: "Error !", message: API.shared.exError ?? "unknown error")
                    return
                }
                Alert1Action(VC:VC,title: "Error on logout!", message: "")
                return
            }
            VC.dismiss(animated: true, completion: nil)
        }
    }
}

