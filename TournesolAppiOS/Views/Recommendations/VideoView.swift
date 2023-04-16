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
            ZStack(alignment: .bottomTrailing) {
                URLImage(url: imageUrl,
                         content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                })
                Text(durationToString(duration: video.metadata.duration))
                    .padding(EdgeInsets(
                        top: 1,
                        leading: 2,
                        bottom: 1,
                        trailing: 2
                    ))
                    .background(Color.black)
                    .foregroundColor(.white)
                    .font(.caption)
                    .fontWeight(.bold)
                    .cornerRadius(4)
                    .offset(x: -5, y: -5)
            }
            HStack(alignment: .center, spacing: 10 ) {
                VStack(alignment: .leading) {
                    VStack(alignment: .center, spacing: 2) {
                        Image("Logo")
                            .imageScale(.medium)
                        Text(String(format: "%02d", Int(video.tournesol_score)))
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                    }
                }
                VStack(alignment: .leading, spacing: 5) {
                    Text(video.metadata.name)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                    Text(video.metadata.uploader +
                         " • " + formatViews(views: video.metadata.views) + " • " +
                         formatDateDisplay(dateString: String(video.metadata.publication_date.prefix(10))))
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.secondaryLabel))
                    HStack(alignment: .top, spacing: 0) {
                        Text(String(video.n_comparisons) + " comparisons • ")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .italic()
                        Text(String(video.n_contributors) + " contributors")
                            .font(.caption)
                            .foregroundColor(Color(UIColor.secondaryLabel))
                            .italic()
                    }
                }
                .foregroundColor(Color.gray).shadow(radius: 0)
            }
            .padding(EdgeInsets(
                top: 0,
                leading: 5,
                bottom: 10,
                trailing: 5
            ))
        }
        .cornerRadius(10)
        .onTapGesture {
            playInYoutube(youtubeId: video.metadata.video_id)
        }
    }
}

