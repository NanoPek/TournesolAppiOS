//
//  RecommendationsHome.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 12/03/2023.
//

import SwiftUI



struct RecommendationsHome: View {

    var body: some View {
        Querier(title: "All videos",
                urlString: "https://api.tournesol.app/polls/videos/recommendations/",
                baseDateFilter: DateFilter.MonthAgo.rawValue
        )
    }
}

struct RecommendationsHome_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsHome()
    }
}
