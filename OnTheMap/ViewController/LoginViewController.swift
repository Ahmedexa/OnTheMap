//
//  loginViewController.swift
//  OnTheMap
//
//  Created by Ahmed Alsamani on 26/12/2018.
//  Copyright © 2018 Ahmed Alsamani. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillDisappear(_ animated: Bool) {
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if (username!.isEmpty) || (password!.isEmpty) {
            let requiredInfoAlert = UIAlertController (title: "Fill the required fields", message: "Please fill both the email and password", preferredStyle: .alert)
            requiredInfoAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            
            self.present (requiredInfoAlert, animated: true, completion: nil)
            
        } else {
            API.shared.login(username: username!, password: password!) { (user) in
                 DispatchQueue.main.async {
        
                    if (user == nil) {
                        guard API.shared.exError == "" else {
                            Alert1Action (VC:self,title: "Error !", message: API.shared.exError ?? "unknown error")
                            return
                        }
                        Alert1Action (VC:self,title: "Erorr logging in", message: "incorrect email or password")
                    } else {
                        API.shared.key = user!.account!.key!
                        API.shared.id = user!.session!.id!
                        print ("the key is \(String(describing: API.shared.key))")
                        
                        API.shared.getPublicUserData() { (UdacityUser) in
                            DispatchQueue.main.async {
                                if (UdacityUser == nil) {return}
                                API.shared.nickname = UdacityUser?.nickname
                                var components = API.shared.nickname!.components(separatedBy: " ")
                                if(components.count > 0)
                                {
                                    API.shared.firstName = components.removeFirst()
                                    API.shared.lastName = components.joined(separator: " ")
                                }
                                self.performSegue(withIdentifier: "TabBarController", sender: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
