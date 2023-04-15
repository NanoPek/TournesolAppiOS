//
//  VideoView.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 12/03/2023.
//

import SwiftUI
import URLImage

struct VideoView: View {
    
    func playInYoutube(youtubeId: String) -> Void {
        if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
    
    var video: TournesolVideo
    var body: some View {
        let imageUrl =  URL(string:"https://i.ytimg.com/vi/" + video.metadata.video_id + "/mqdefault.jpg")!
        VStack(alignment: .leading) {
            URLImage(url: imageUrl,
                     content: { image in
                         image
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                     })
            VStack(alignment: .leading) {
                Text(video.metadata.name)
                HStack {
                    Text(String(video.metadata.views) + " views")
                    Text(video.metadata.publication_date.prefix(10))
                    Text(video.metadata.uploader)
                }.foregroundColor(Color.gray).shadow(radius: 0)
                HStack {
                    HStack(alignment: .center, spacing: 2.0) {
                        Image("Logo")
                        Text(String(Int(video.tournesol_score)))
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    Text(String(video.n_comparisons) + " comparisons by " + String(video.n_contributors) + " contributors")
                        .foregroundColor(Color.gray).italic()
                }.shadow(radius: 0)
            }.padding([.leading, .trailing], 10.0)
        }.onTapGesture {
            playInYoutube(youtubeId: video.metadata.video_id)
        }
    }
}

