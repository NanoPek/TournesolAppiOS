//
//  FeaturedHome.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import SwiftUI
import URLImage



struct FeaturedHome: View {

    @State var recommendations = [String : Recommendation]()
    @State var dateFilter = DateFilter.MonthAgo
    @State var limit = 30
    @State var newFilter = false
    
    let currentDate = Date()
    
    func paramBuilder(parameters: [String: StringOrStringList?]) -> [URLQueryItem] {
        var result = [URLQueryItem]()
        parameters.forEach { parameter in
            if let stringArray = parameter.value as? [LanguageToken] {
                let languageTokens = stringArray as [LanguageToken]
                let languages = languageTokens.map { $0.rawValue }
                languages.forEach { language in
                    result.append(URLQueryItem(name: parameter.key, value: language))
                }
            } else {
                result.append(URLQueryItem(name: parameter.key, value: parameter.value as? String))
            }
        }
        return result
        }
    
    func queryAPIWeights(featureCategory: FeaturesCategories, weights: [String : String]) {
        var baseParams = [
            "limit" : String(limit),
            "metadata[language]" : [LanguageToken.English,LanguageToken.French],
        ] as [String : StringOrStringList]
        baseParams = baseParams + weights
        let urlParams = paramBuilder(parameters: baseParams)
        decodeAPI(parameters: urlParams, urlString: "https://api.tournesol.app/polls/videos/recommendations/") { response in
            if let response = response {
                recommendations[featureCategory.rawValue] = response
            }
        }
    }
    
    func queryAPIs() {
        FeaturesCategories.allCases.forEach { category in
            var categoryWeights = weights
            if (category == FeaturesCategories.Daily) {
                categoryWeights = ["date_gte": formatDate(currentDate: currentDate, task: DateFilter.DayAgo)]
            } else if (category == FeaturesCategories.Latest) {
                categoryWeights = ["date_gte": formatDate(currentDate: currentDate, task: DateFilter.WeekAgo)]
            } else {
                categoryWeights["weights[" + category.rawValue + "]"] = "100"
                categoryWeights["date_gte"] = formatDate(currentDate: currentDate, task: dateFilter)
            }
            queryAPIWeights(featureCategory: category, weights: categoryWeights)
        }
    }
    
    var body: some View {
        NavigationView {
            if (recommendations.count == 0) {
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(150)
            } else {
                ScrollView {
                    VStack {
                        if ( recommendations[FeaturesCategories.Latest.rawValue] != nil ) {
                            VideoView(video: recommendations[FeaturesCategories.Daily.rawValue]?.results[0] ?? recommendations[FeaturesCategories.Latest.rawValue]!.results[0])
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                        }
                        ForEach(FeaturesCategories.allCases, id: \.self) { key in
                            if ((recommendations[key.rawValue]) != nil && key != FeaturesCategories.Daily) {
                                FeaturedRow(category: key, items: recommendations[key.rawValue]!.results)
                            }
                        }
                    }
                    .navigationTitle("Featured")
                    .padding([.leading, .trailing], 10)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Picker("", selection: Binding(
                                get: {
                                    self.dateFilter
                                }, set: { (newValue) in
                                    self.newFilter = true
                                    self.dateFilter = newValue
                                    self.queryAPIs()
                                }))
                            {
                                ForEach(DateFilter.allFilters, id: \.self)
                                {
                                    filter in
                                    Text(filter.rawValue)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            queryAPIs()
        }
    }
}
