//
//  LoginPages.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 24/04/2023.
//

import Foundation

enum LoginPages: String
{
    static var allFilters: [LoginPages]
    {
        return [.MyRatedList, .MyRateLaterList]
    }
    
    func icon() -> String {
        switch self {
        case .MyRatedList:
            return "list.star"
        case .MyRateLaterList:
            return "hourglass"
        }
        
    }
    
    case MyRatedList = "My rated videos"
    case MyRateLaterList = "To rate later"
}
