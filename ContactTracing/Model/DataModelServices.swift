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
        
        var requestBodyComponents = URLComponents()
        
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password),
            URLQueryItem(name: "device_token", value: device_token),
        ]
        
        
        var request = URLRequest(url: URL(string:"http://localhost:4000/login")!)
        request.httpMethod = "POST"
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        //let postString = "username=\(username)&password=\(password)&device_token=\(device_token)";
        //print("postString: \(postString)")
        // Set HTTP Request Body
        //var request = self.postRequest(methodName: "login", postString: postString)
        print("the request is: ")
        print(request)
        print("that was the request")
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // check HTTP Response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let login_token = String(data: data, encoding: .utf8) {
                print("Response string:\n \(login_token)")
                callback(login_token) // return a login_token string
            }
        }
        task.resume()
        
    }
    
    
    //app signup req(username: string, password: string) res(success: bool)
    
    func signup(username: String, password: String, callback: @escaping () -> Void) {
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(username)&password=\(password)";
        // Set HTTP Request Body
        let request = self.postRequest(methodName: "signup", postString: postString)
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // check HTTP Response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
        }
        task.resume()
        
    }
    
    
    //get locations of the user req(username: string, login_token: int) res(locations: [Location])
    // "https://localhost:4000/getLocation"
    
    func getLocation(username: String, login_token: String, callback: @escaping (LocationObject) -> Void) {
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(username)&login_token=\(login_token)";
        // Set HTTP Request Body
        let request = self.postRequest(methodName: "getLocation", postString: postString)
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // check HTTP Response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            // Convert HTTP Response Data to a String
            
            guard let data = data else {
                // TODO: Deal with the error if this is an error
                return
            }
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(LocationObject.self, from: data)
                
                callback(decoded) // return LocationObject
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    
    // log location
    //req(username: string, login_token: string, latitude: double, longtitude: double) res()
    
    func logLocation(username: String, login_token: String, latitude: Double, longtitude: Double, callback: @escaping () -> Void) {
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString = "username=\(username)&login_token=\(login_token)&latitude=\(latitude)&longtitude=\(longtitude)";
        // Set HTTP Request Body
        let request = self.postRequest(methodName: "logLocation", postString: postString)
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // check HTTP Response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
        }
        task.resume()
    }
    
    // Helping method that prepare URL
    func postRequest(methodName: String, postString: String) -> URLRequest {
        let url = URL(string: "http://localhost:4000/\(methodName)")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        return request
        
    }
}

