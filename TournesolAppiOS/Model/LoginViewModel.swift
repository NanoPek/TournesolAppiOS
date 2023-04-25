//
//  LoginViewModel.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 25/04/2023.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = (UserDefaults.standard.string(forKey: "username") ?? "")
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoggedIn: Bool = (UserDefaults.standard.string(forKey: "username") != nil
                                       && UserDefaults.standard.string(forKey: "access_token") != nil)
    @Published var error: String = ""
    
    func login() {
        isLoading = true
        
        // Perform login logic here, for example sending the credentials to a server or checking them against a local database.
        // In this example, assume that the login API returns a token in the response.
        let response = sendLoginRequest(username: username, password: password)
        if let token = response["access_token"] as? String {
            // Save the token in UserDefaults
            let username = response["username"] as? String
            UserDefaults.standard.set(token, forKey: "access_token")
            UserDefaults.standard.set(username, forKey: "username")
            UserDefaults.standard.synchronize()
            
            isLoggedIn = true
            isLoading = false
        } else {
            error = "Invalid Login"
            isLoading = false
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.synchronize()
        
        password = ""
        isLoggedIn = false
    }
}

func sendLoginRequest(username: String, password: String) -> [String: Any] {
    let url = URL(string: "https://api.tournesol.app/o/token/")! // Replace with the actual login API URL
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.addValue("Basic dVVoY3RLRDZDNUxDNHJQa2tsbnNoeWxjcjNQSEhROERUWEJvbjhNeDp5V2VVd2lrOElydFo4cHdpSWFGZUNoNnZHdnA4dkNLeXhmbjhOOGNRTWQ3OXhNMmdmS1NNQm9zU2d6Q3BJeVh1VGxTQ3dZQ1dvWlNuRXlqbHFObnFvODlNamVOTkFiTlQ0M0dBS3Q3V3Zva01RREVRb1dlMGVmMWVkOHhZWFBObg==", forHTTPHeaderField: "authorization")
    
    let requestBody = "grant_type=password&username=\(username)&password=\(password)&scope=read+write+groups&response_type=code+id_token+token"
    request.httpBody = requestBody.data(using: .utf8)
    
    var responseDict: [String: Any] = [:]
    
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    responseDict = json
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        semaphore.signal()
    }
    
    task.resume()
    semaphore.wait()
    
    print(responseDict)
    
    return responseDict
}
