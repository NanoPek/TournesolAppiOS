//
//  RatedVideoContextMenu.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 24/04/2023.
//

import Foundation
import SwiftUI


struct RatedVideoContextMenu: View {
    let video: RatedTournesolVideo
    let page: LoginPages
    let query: () -> ()
    
    func redirectToURL(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func deleteItem(url: String, token: String) {
        let semaphore = DispatchSemaphore(value: 0)

        guard let url = URL(string: url) else {
            print("Invalid URL")
            semaphore.signal()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }

            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Handle response data, if any
            if let data = data {
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
        
        semaphore.wait()
    }


    var body: some View {
        Button {
            redirectToURL(url: "https://tournesol.app/entities/yt:\(video.metadata.video_id)")
        } label: {
            Label("Get details", systemImage: "questionmark.circle")
        }
        
        if (page == LoginPages.MyRatedList) {
            Button {
                redirectToURL(url: "https://tournesol.app/comparisons/?uid=yt:\(video.metadata.video_id)")
            } label: {
                Label("Get my comparisons ", systemImage: "list.star")
            }
        }
        
        if (page == LoginPages.MyRateLaterList) {
            Button {
                deleteItem(url: "https://api.tournesol.app/users/me/rate_later/videos/yt:\(video.metadata.video_id)/", token: UserDefaults.standard.string(forKey: "access_token")!)
                query()
            } label: {
                Label("Remove from list", systemImage: "trash")
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
