//
//  NetworkManager.swift
//  Assignment_API_Sqlite
//
//  Created by Mirajkar on 01/06/21.
//  Copyright © 2021 Mirajkar. All rights reserved.
//

import Foundation


class NetworkManager {
    
    static var shared = NetworkManager()
    
    private init() { }
    
    var defaultSession = URLSession(configuration: .default)
    var dataTask : URLSessionTask?
    var users : [User] = []
    var errorMessage = ""
    
    //MARK: API Call
    func getUsersInfo(completion: @escaping (String) -> Void) {
        dataTask?.cancel()
        
        let urlString  = "https://jsonplaceholder.typicode.com/users"
        guard let url = URL(string: urlString) else {
            print("Error while url \(urlString)")
            return
        }
        
        dataTask = defaultSession.dataTask(with: url, completionHandler: { (data, respose, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else if
                let data  = data,
                let response = respose as? HTTPURLResponse,
                response.statusCode == 200 {
                self.insertIntoDatabase(data: data)
                DispatchQueue.main.async {
                    completion(self.errorMessage)
                }
            }
        })
        dataTask?.resume()
    }
    
    
    func insertIntoDatabase(data: Data) {
        var response : [Any]?
        
        do {
            response =  try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
        } catch let error as NSError {
            self.errorMessage = error.localizedDescription
        }
        
        guard let userArray = response else {
            return
        }
        
        for userDict in userArray {
            
            if let userDict = userDict as? [String : Any],
                let id = userDict["id"] as? Int,
                let name = userDict["name"] as? String,
                let email = userDict["email"] as? String,
                let address = userDict["address"] as? [String : Any],
                let zipcode = address["zipcode"] as? String,
                let company = userDict["company"] as? [String : Any],
                let companyName = company["name"] as? String {
                DBHelper.shared.insert(userObj: User(id: id, name: name, email: email, zipcode: zipcode, companyName: companyName))
            } else {
                print("Error in User Dict")
            }
            
        }
    }
}



