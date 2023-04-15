//
//  ContentView.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 12/03/2023.
//

import SwiftUI



struct ContentView: View {
    
    @State var recommendation: Recommendation?
    
    var body: some View {
        VStack() {
            Header()
            VStack(alignment: .leading) {
                    Text("Recommendations")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Divider()
                    List {
                        if (recommendation != nil) {
                            ForEach(recommendation!.results) { result in VideoView(video: result)}
                        }
                    }
            }
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(red: 0.9803921568627451, green: 0.9725490196078431, blue: 0.9529411764705882)/*@END_MENU_TOKEN@*/)
        }
        .ignoresSafeArea()
        .onAppear {
            decodeAPI() { response in
                if let response = response {
                    recommendation = response
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
