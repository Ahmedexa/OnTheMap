//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Ahmed Alsamani on 30/12/2018.
//  Copyright © 2018 Ahmed Alsamani. All rights reserved.
//

import Foundation
import UIKit

class API {
    static var shared = API()
    private init() {}
    
    var key: String?
    var id: String?
    var latitude:Double?
    var longitude:Double?
    var mapString: String? = ""
    var mediaURL: String? = ""
    var objectId: String? = ""
    var firstName: String? = ""
    var lastName: String? = ""
    var nickname: String? = ""
    
    var exError: String?
    
    var user: StudentLocation?
    
    func login(username: String, password: String, completion: @escaping (_ object: User?) -> Void) {
        let params = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let url = "https://onthemap-api.udacity.com/v1/session"
        let method = "POST"
        request(url: url, method: method, parameters: params, completion: completion)
    }
    func getPublicUserData(completion: @escaping (_ object: UdacityUserData?) -> Void) {
        guard API.shared.id != nil else { return }
        let url = "https://onthemap-api.udacity.com/v1/users/\(API.shared.id ?? "")"
        let method = "GET"
        request(url: url, method: method, completion: completion)
    }
    
    func logout( completion: @escaping (_ object: UserSession?) -> Void) {
       let url =  "https://onthemap-api.udacity.com/v1/session"
       let method = "DELETE"
       request(url: url, method: method, completion: completion)
    }
    
    func getStudentsLocations(limit: Int = 100, skip: Int = 0, orderBy: String = "updatedAt", completion: @escaping (_ locations: StudentLocationResult?) -> Void) {
        let url = "https://parse.udacity.com/parse/classes/StudentLocation?limit=\(limit)&skip=\(skip)&order=-\(orderBy)"
        let method = "GET"
        request(url: url, method: method, completion: completion)
    }
    
    func getUserInfo(completion: @escaping (_ object: StudentLocationResult?) -> Void) {
        guard API.shared.key != nil else { return }
        let url = "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(API.shared.key ?? "")%22%7D"
        let method = "GET"
        request(url: url, method: method, completion: completion)
    }
    
    func postLocation(_ location: StudentLocation, completion: @escaping (_ object:StudentLocation?) -> Void) {
        let url = "https://parse.udacity.com/parse/classes/StudentLocation"
        let method = "POST"
        var params: Data?
        do {
            params = try JSONEncoder().encode(location)
        } catch {
            print(error)
        }
        request(url: url, method: method, parameters: params, completion: completion)
    }
    
    func updateLocation(_ location: StudentLocation, completion: @escaping (_ object:StudentLocation?) -> Void) {
        let url = "https://parse.udacity.com/parse/classes/StudentLocation/\(API.shared.objectId ?? "")"
        let method = "PUT"
        var params: Data?
        do {
            params = try JSONEncoder().encode(location)
        } catch {
            print(error)
        }
        request(url: url, method: method, parameters: params, completion: completion)
    }
    
    func request<SomeType: Decodable>(url: String, method: String, parameters: Data? = nil, completion: @escaping (_ object: SomeType?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        request.httpBody = parameters
        
        if method == "DELETE" {
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        API.shared.exError = ""
        
        guard Reachability.isConnectedToNetwork() else {
            API.shared.exError = "Internet Connection not Available!"
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
        guard (error == nil) else {
            API.shared.exError =  "There was an error with your request: \(error!.localizedDescription)"
            completion(nil)
            return
        }

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
            let data = data,
            (statusCode > 199 && statusCode < 300) else {
                completion(nil)
                return
        }
        
        do {
            let result = try JSONDecoder().decode(SomeType.self, from: data)
            completion(result)
        } catch {
            if (error as NSError).code == 3840 || (error as NSError).code == 4864 {
                let data = data.subdata(in: 5..<data.count)
                do {
                    let result = try JSONDecoder().decode(SomeType.self, from: data)
                    completion(result)
                } catch {
                    print(error)
                    completion(nil)
                }
            } else {
                print(error)
                completion(nil)
            }
            }
        }.resume()
    }
}


func Alert (VC:UIViewController , title:String, message:String)
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
        alert.dismiss(animated: true, completion: nil) 
    }))
    VC.present(alert, animated: true, completion: nil)
}
