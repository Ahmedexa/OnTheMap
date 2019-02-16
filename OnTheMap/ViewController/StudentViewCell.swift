//
//  StudentViewCell.swift
//  OnTheMap
//
//  Created by Ahmed Alsamani on 10/01/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import UIKit

class StudentViewCell: UITableViewCell {
    

    @IBOutlet weak var URL: UILabel!   
    @IBOutlet weak var NameLable: UILabel!
    @IBOutlet weak var photoimage: UIImageView!
    func fillCell(usersData: StudentLocation) {
        
        if let frist = usersData.firstName , let last = usersData.lastName , let url = usersData.mediaURL {
            
            NameLable.text = "\(frist) \(last)"
            URL.text = "\(url)"
            
        }
    }
}

