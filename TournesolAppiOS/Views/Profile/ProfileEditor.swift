//
//  ProfileEditor.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile

    var body: some View {
        List {

            VStack(alignment: .leading, spacing: 20) {
                Picker("Upload date", selection: $profile.preferredDate) {
                    ForEach(DateFilter.allFilters, id: \.self)
                    {
                        filter in
                        Text(filter.rawValue)
                    }
                }
                
                Toggle(isOn: $profile.english ) {
                    Text("Display English videos").bold()
                }
                
                Toggle(isOn: $profile.french) {
                    Text("Display French videos").bold()
                }
            }
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
