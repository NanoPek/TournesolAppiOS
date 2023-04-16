//
//  FeaturedHome.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import SwiftUI
import URLImage



struct FeaturedHome: View {
    @EnvironmentObject var modelData: ModelData
    
    @State var recommendations = [String : Recommendation]()
    
    @State var dateFilter = DateFilter.MonthAgo
    
    @State var limit = 30
    
    @State var newFilter = false
    
    @State private var showingProfile = false


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
        decodeAPI(parameters: urlParams) { response in
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
            List {
                if ( recommendations[FeaturesCategories.Daily.rawValue] != nil ) {
                    VideoView(video: recommendations[FeaturesCategories.Daily.rawValue]!.results[0])
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(UIColor.secondarySystemGroupedBackground))
                        )
                }
                ForEach(FeaturesCategories.allCases, id: \.self) { key in
                    if ((recommendations[key.rawValue]) != nil && key != FeaturesCategories.Daily) {
                        FeaturedRow(category: key, items: recommendations[key.rawValue]!.results)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
            .listStyle(.insetGrouped)
            .listRowSeparator(.hidden)
            .navigationTitle("Featured")
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
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
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }
        }
        .onAppear {
            dateFilter = modelData.profile.preferredDate
            print(dateFilter)
            queryAPIs()
        }
    }
}
