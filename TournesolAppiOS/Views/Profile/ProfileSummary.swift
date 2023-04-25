//
//  ProfileSummary.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import SwiftUI

struct ProfileSummary: View {
    var profile: Profile

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Preferences")
                    .font(.largeTitle)
                
                Text("Upload date : \(profile.preferredDate.rawValue)")
                    .padding(.leading)
                
                Text("English videos : \(profile.english ? "On": "Off" )")
                    .padding(.leading)

                
                Text("French videos : \(profile.french ? "On": "Off" )")
                    .padding(.leading)

            }
            .padding()
        }
    }
}

struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
            .environmentObject(ModelData())
    }
}
