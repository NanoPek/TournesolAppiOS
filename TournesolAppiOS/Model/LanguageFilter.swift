//
//  LanguageFilter.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import Foundation
import SwiftUI

enum LanguageToken: String, Hashable, CaseIterable, Identifiable {
    case English = "en"
    case French = "fr"
    
    var id: String { rawValue }

    func icon() -> String {
        switch self {
            case .English:
               return "flag"
            case .French:
               return "flag"
        }
    }
    
    func fullName() -> String {
        switch self {
            case .English:
               return "English"
            case .French:
               return "Français"
        }
    }
    
}

