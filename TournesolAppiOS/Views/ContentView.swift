//
//  ContentView.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 12/03/2023.
//

import SwiftUI



struct ContentView: View {
    
    @State private var selection: Tab = .featured
    
    enum Tab {
        case featured
        case list
    }
    
    var body: some View {
        TabView(selection: $selection) {
            FeaturedHome()
                .tabItem {
                    Label("Featured", systemImage: "star")
                }
                .tag(Tab.featured)
            
            RecommendationsHome()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.featured)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
