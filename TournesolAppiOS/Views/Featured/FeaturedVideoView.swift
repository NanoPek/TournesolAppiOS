//
//  FeaturedVideoView.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import SwiftUI
import URLImage

struct FeaturedVideoView: View {
    
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
        VStack(spacing: 0 ) {
            ZStack(alignment: .topLeading) {
                ZStack(alignment: .bottomTrailing) {
                    URLImage(url: imageUrl,
                             content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    })
                    .cornerRadius(5, corners: [.topLeft, .topRight])
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
                Text(String(format: "%02d", Int(video.tournesol_score)))
                    .padding(EdgeInsets(
                        top: 1,
                        leading: 2,
                        bottom: 1,
                        trailing: 2
                    ))
                    .font(.title)
                    .foregroundColor(.accentColor)
                    .background(Color.black)
                    .fontWeight(.bold)
                    .cornerRadius(4)
                    .offset(x: 5, y: 5)
            }
            .background(Color(UIColor.secondarySystemGroupedBackground))
            VStack(alignment: .leading, spacing: 5) {
                Text(video.metadata.name)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                Text(video.metadata.uploader +
                     " • " + formatViews(views: video.metadata.views) + " • " +
                     formatDateDisplay(dateString: String(video.metadata.publication_date.prefix(10))))
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }
            .foregroundColor(Color.gray).shadow(radius: 0)
            .padding(5)
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(5, corners: [.bottomLeft, .bottomRight])
            Spacer()
        }
        .cornerRadius(5)
        .onTapGesture {
            playInYoutube(youtubeId: video.metadata.video_id)
        }
        .contextMenu {
            VideoContextMenu(video: video)
        }
    }
}


