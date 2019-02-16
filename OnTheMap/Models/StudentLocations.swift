//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Ahmed Alsamani on 11/01/2019.
//  Copyright © 2019 Ahmed Alsamani. All rights reserved.
//

import Foundation
import UIKit

import Foundation

struct StudentsLocations {
    
    static var shared = StudentsLocations()
    
    private init() {}
    
    var studentLocation = [StudentLocation]()
    
}

struct StudentLocation: Codable {
    
    var createdAt: String? 
    var firstName: String? = ""
    var lastName: String? = ""
    var latitude: Double? = 23
    var longitude: Double? = 42
    var mapString: String? = ""
    var mediaURL: String? = ""
    var objectId: String?
    var uniqueKey: String? = API.shared.key
    var updatedAt: String?
    
    init(
        mapString: String? = ""){
        self.mapString = mapString
    }
}

struct StudentLocationResult: Codable {
    var results: [StudentLocation]?
}

struct User: Codable {
    var session: UserSession?
    var account: UserAccount?
}

struct UserAccount: Codable {
    var key: String?
}

struct UserSession: Codable {
    var id: String?
    var expiration : String?
}

struct UdacityUserData : Codable {
    let nickname : String?
    
}

struct NONE: Decodable {}


