//
//  MainViewController.swift
//  OnTheMap
//
//  Created by Ahmed Alsamani on 31/12/2018.
//  Copyright © 2018 Ahmed Alsamani. All rights reserved.
//

import Foundation

import UIKit


    func Alert2Action (VC: UIViewController, title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            VC.performSegue(withIdentifier: "AddLocation", sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("No!")
        }))
        
        VC.present(alert, animated: true, completion: nil)
    }
    
    func Alert1Action(VC: UIViewController,title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        VC.present(alert, animated: true, completion: nil)
    }

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
