//
//  RecommendationsHome.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 12/03/2023.
//

import SwiftUI



struct RecommendationsHome: View {
    
    @State var recommendation: Recommendation?
    
    @State var dateFilter = DateFilter.MonthAgo
        
    @State var searchQuery = ""
    
    @State var selectedLanguageTokens = [LanguageToken]()
    @State var suggestedLanguageTokens = LanguageToken.allCases
    
    @State var limit = 30
    
    @State var newFilter = false

    let currentDate = Date()
    
    private let itemsFromEndThreshold = 15
    
    
    func requestMoreItemsIfNeeded(index: Int) {
        if thresholdMeet(limit, index) {
            limit += 30
            queryAPI()
        }
    }

    private func thresholdMeet(_ itemsLoadedCount: Int, _ index: Int) -> Bool {
        return (itemsLoadedCount - index) == itemsFromEndThreshold
    }
    
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
    
    func queryAPI() {
        if newFilter {
            limit = 20
            newFilter = false
        }
        let urlParams = paramBuilder(parameters: [
            "limit" : String(limit),
            "metadata[language]" : selectedLanguageTokens,
            "date_gte": formatDate(currentDate: currentDate, task: dateFilter),
            "search": searchQuery
        ])
        decodeAPI(parameters: urlParams) { response in
            if let response = response {
                recommendation = response
            }
        }
    }
            
    
    var body: some View {
        NavigationView {
            if let items = recommendation?.results.enumerated().map({$0}) {
                List(items, id: \.element.id) { index, item in
                    VideoView(video: item)
                        .padding(EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 20,
                            trailing: 0
                        ))
                        .onAppear { requestMoreItemsIfNeeded(index: index) }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(UIColor.secondarySystemGroupedBackground))
                                .padding(
                                    EdgeInsets(
                                        top: 0,
                                        leading: 0,
                                        bottom: 20,
                                        trailing: 0
                                    )
                                )
                        )
                        .listRowSeparator(.hidden)
                }
                .navigationTitle("Videos")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Picker("", selection: Binding(
                            get: {
                                self.dateFilter
                            }, set: { (newValue) in
                                self.newFilter = true
                                self.dateFilter = newValue
                                self.queryAPI()
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
        .searchable(text: Binding(
            get: {
                self.searchQuery
            }, set: { (newValue) in
                self.newFilter = true
                self.searchQuery = newValue
                self.queryAPI()
            }), tokens: $selectedLanguageTokens,
                    suggestedTokens: $suggestedLanguageTokens,
                    token: { token in
            Label(token.fullName(), systemImage: token.icon())
        })
        .onAppear {
            queryAPI()
        }
    }
}

struct RecommendationsHome_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationsHome()
    }
}
