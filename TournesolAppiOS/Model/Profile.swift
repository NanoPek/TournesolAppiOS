//
//  Profile.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 16/04/2023.
//

import Foundation

struct Profile {
    var preferredLanguages: [LanguageToken]
    var preferredDate: DateFilter
    var english: Bool
    var french: Bool

    static let `default` = Profile(
        preferredLanguages: [LanguageToken.English, LanguageToken.French],
        preferredDate: DateFilter.MonthAgo,
        english: true,
        french: true
    )
}
