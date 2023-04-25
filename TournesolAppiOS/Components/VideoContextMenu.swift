//
//  VideoContextMenu.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 23/04/2023.
//

import Foundation
import SwiftUI

func createItem(url: String, id: String, token: String) {
    guard let url = URL(string: url) else {
        return
    }
    
    let item = [
        "entity": [
            "uid": "yt:\(id)"
        ]
    ]
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: item, options: []) else {
        return
    }
    
    let semaphore = DispatchSemaphore(value: 0) // Initialize semaphore with value 0
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        defer {
            semaphore.signal() // Signal semaphore when task is finished
        }
        
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        // Handle response data, if any
        if let data = data {
            print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
        }
    }.resume()
    
    semaphore.wait() // Wait for the semaphore to be signaled
}

struct VideoContextMenu: View {
    let video: TournesolVideo
    let token = UserDefaults.standard.string(forKey: "access_token")
    
    func redirectToURL(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    var body: some View {
        Button {
            redirectToURL(url: "https://tournesol.app/entities/yt:\(video.metadata.video_id)")
        } label: {
            Label("Get details", systemImage: "questionmark.circle")
        }
        
        if (token != nil) {
            Button {
                createItem(
                    url: "https://api.tournesol.app/users/me/rate_later/videos/",
                    id: video.metadata.video_id,
                    token: token!
                )
            } label: {
                Label("Rate later", systemImage: "hourglass.badge.plus")
            }
        }
        
        Button {
            redirectToURL(url: "https://tournesol.app/comparison/?uidA=yt:\(video.metadata.video_id)")
        } label: {
            Label("Compare this video", systemImage: "sidebar.left")
        }
        
        ShareLink (item: "https://www.youtube.com/watch?v=\(video.metadata.video_id)")
        {
            Label("Share", systemImage: "square.and.arrow.up")
        }
    }
}
