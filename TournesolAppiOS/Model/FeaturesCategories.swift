//
//  FeaturesCategories.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import Foundation

enum FeaturesCategories: String, Hashable, CaseIterable, Identifiable {
    case Daily = "daily"
    case Latest = "latest"
    case LargelyRecommended = "largely_recommended"
    case Reliability = "reliability"
    case Pedagogy = "pedagogy"
    case Importance = "importance"
    case LaymanFriendly = "layman_friendly"
    case Entertaining = "entertaining_relaxing"
    case Engaging = "engaging"
    case DiversityInclusion = "diversity_inclusion"
    case BetterHabits = "better_habits"
    case BackfireRisk = "backfire_risk"
        
    var id: String { rawValue }
        
    func fullName() -> String {
        switch self {
        case .Daily:
            return "Daily"
        case .Latest:
            return "Latest Videos"
        case .LargelyRecommended:
            return "Best Tournesol Score"
        case .Reliability:
            return "Reliable & not misleading"
        case .Pedagogy:
            return "Clear & pedagogical"
        case .Importance:
            return "Importanct & actionable"
        case .LaymanFriendly:
            return "Layman-friendly"
        case .Entertaining:
            return "Entertaining & relaxing"
        case .Engaging:
            return "Engaging & thought-provoking"
        case .DiversityInclusion:
            return "Diversity & inclusion"
        case .BetterHabits :
            return "Encourages better habits"
        case .BackfireRisk:
            return "Resilience to backfiring risks"
        }
    }
}

let weights = [
    "weights[largely_recommended]" : "0",
    "weights[reliability]" : "0",
    "weights[pedagogy]" : "0",
    "weights[importance]" : "0",
    "weights[layman_friendly]" : "0",
    "weights[entertaining_relaxing]" : "0",
    "weights[engaging]" : "0",
    "weights[diversity_inclusion]" : "0",
    "weights[better_habits]" : "0",
    "weights[backfire_risk]" : "0",
]
