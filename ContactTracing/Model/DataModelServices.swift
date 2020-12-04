//
//  DataModelServices.swift
//  ContactTracing
//
//  Created by Wameedh Mohammed Ali on 12/3/20.
//

import Foundation

struct DataModelServices {
    
    // request params: username, pass, device_token
           // response: login_token
           
           // "https://localhost:4000/login"
    
func login(username: String, password: String, device_token: String, callback: @escaping (String) -> Void) {
    
    // Prepare URL
    let url = URL(string: "https://localhost:4000/login")
    guard let requestUrl = url else { fatalError() }
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
     
    // HTTP Request Parameters which will be sent in HTTP Request Body
    let postString = "username=\(username)&password=\(password)&device_token=\(device_token)";
    // Set HTTP Request Body
    request.httpBody = postString.data(using: String.Encoding.utf8);
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
     
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
     
            // Convert HTTP Response Data to a String
            if let data = data, let login_token = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(login_token)")
                callback(login_token)
            }
    }
    task.resume()
    
}
}
