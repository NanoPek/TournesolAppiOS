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
        case recommendations
        case profile
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
                    Label("All videos", systemImage: "play.rectangle.on.rectangle")
                }
                .tag(Tab.recommendations)
            
            LoginHome()
                .tabItem {
                    Label("My ratings", systemImage: "person.badge.shield.checkmark")
                }
                .tag(Tab.profile)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
