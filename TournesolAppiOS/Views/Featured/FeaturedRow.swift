//
//  FeaturedRow.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import SwiftUI

struct FeaturedRow: View {
    var category: FeaturesCategories
    var items: [TournesolVideo]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                Image(category.rawValue)
                Text(category.fullName())
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(items) { video in
                        FeaturedVideoView(video: video)
                            .frame(maxWidth: 165, maxHeight: 185)
                    }
                }
            }
            .padding(0)
        }
        .background(Color(UIColor.systemBackground))
    }
}
