//
//  AddVideoFromLink.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 25/04/2023.
//

import Foundation
import SwiftUI
import URLImage

func youtubeParser(url: String) -> String? {
    let regExp = try! NSRegularExpression(pattern: "^.*((youtu.be\\/)|(v\\/)|(\\/u\\/\\w\\/)|(embed\\/)|(watch\\?))\\??v?=?([^#&?]*).*")
    let range = NSRange(location: 0, length: url.utf16.count)
    let match = regExp.firstMatch(in: url, range: range)
    if let match = match, match.numberOfRanges >= 8 {
        let start = match.range(at: 7).location
        let end = match.range(at: 7).length
        let range = NSRange(location: start, length: end)
        let videoID = (url as NSString).substring(with: range)
        if videoID.count == 11 {
            return videoID
        }
    }
    return nil
}


struct AddVideoFromLink: View {
    @Environment(\.presentationMode) var presentationMode
    
    let query: () -> ()
    
    @State var videoURL: String = ""
    
    @State var showingAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 10) {
                Text("Add videos to your rate-later list")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Text("Copy-paste the id or the URL of a favorite video of yours. You will then be able to compare the videos you imported. They will be automatically removed from your list once you have enough comparisons.")
                    .multilineTextAlignment(.leading)
                if (youtubeParser(url: videoURL) != nil) {
                    let imageUrl =  URL(string:"https://i.ytimg.com/vi/" + youtubeParser(url: videoURL)! + "/mqdefault.jpg")!
                    URLImage(url: imageUrl,
                             content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    })
                }
                Form {
                    TextField("Paste Youtube video link", text: $videoURL)
        
                    Button(action: {
                        createItem(
                            url: "https://api.tournesol.app/users/me/rate_later/videos/",
                            id: youtubeParser(url: videoURL)!,
                            token: UserDefaults.standard.string(forKey: "access_token")!
                        )
                        query()
                        showingAlert = true // Set showingAlert to true after creating the item
                    }) {
                        Label("Rate later", systemImage: "hourglass.badge.plus")
                    }
                    .disabled(videoURL.count == 0 || youtubeParser(url: videoURL) == nil)
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Video added!"),
                            message: Text("The video has been added to your rate later list."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .navigationBarItems(trailing: Button("Done") {
                    self.presentationMode.wrappedValue.dismiss()
                })
            }
            .padding(10)
        }
    }
}
