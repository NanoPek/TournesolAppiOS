//
//  TournesolAppiOSApp.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 12/03/2023.
//

import SwiftUI

@main
struct TournesolAppiOSApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        return WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
