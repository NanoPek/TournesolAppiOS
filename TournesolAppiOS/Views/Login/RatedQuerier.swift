//
//  RatedQuerier.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 24/04/2023.
//

import Foundation
import SwiftUI


struct RatedQuerier: View {

    let title: String
    let urlString: String
    let token: String
    let page: LoginPages
    
    @State var recommendation: MyRatedItems?
    @State private var showingForm = false
                
    @State var limit = 30
    
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
    
    func requestMoreItemsIfNeeded(index: Int) {
        if thresholdMeet(limit, index) {
            limit += 30
            queryAPI()
        }
    }
    
    private func thresholdMeet(_ itemsLoadedCount: Int, _ index: Int) -> Bool {
        return (itemsLoadedCount - index) == itemsFromEndThreshold
    }

    
    func queryAPI() {
        let urlParams = paramBuilder(parameters: [
            "limit" : String(limit),
        ])
        decodeAPIRated(parameters: urlParams, urlString: urlString, token: token) { response in
            if let response = response {
                recommendation = response
            }
        }
    }

    var body: some View {
        VStack {
            if (recommendation == nil) {
                Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(150)
            } else {
                let items = recommendation!.results.enumerated().map({$0})
                List(items, id: \.element.id) { index, item in
                    RatedVideoView(
                        video: item.entity,
                        n_comparisons: item.n_comparisons
                    )
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
                    .contextMenu {
                        RatedVideoContextMenu(
                            video: item.entity,
                            page: page,
                            query: queryAPI
                        )
                    }
                    }
                }
            }
            .onAppear {
                queryAPI()
            }
            .toolbar {
                if (page == .MyRateLaterList) {
                    ToolbarItem(placement: .automatic) {
                        Button(action: {
                            self.showingForm = true
                        }) {
                            Image(systemName: "link.badge.plus")
                        }
                        .sheet(isPresented: $showingForm) {
                            AddVideoFromLink(query: queryAPI)
                        }
                    }
                }
            }
    }
}
