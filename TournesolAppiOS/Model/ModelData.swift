//
//  ModelData.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var profile = Profile.default

}
