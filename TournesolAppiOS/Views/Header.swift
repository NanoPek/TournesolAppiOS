//
//  Header.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 12/03/2023.
//

import SwiftUI

struct Header: View {
    var body: some View {
        HStack {
            Image("Logo")
            Spacer()
            Text("Tournesol App")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20.0)
        .padding(.top, 40.0)
        .frame(height: 120.0)
        .background(Rectangle()
            .foregroundColor(Color.yellow)
        )
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
