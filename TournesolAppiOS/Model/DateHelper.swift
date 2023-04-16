//
//  DateHelper.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 15/04/2023.
//

import Foundation

enum DateFilter: String
{
    static var allFilters: [DateFilter]
    {
        return [.DayAgo,.WeekAgo,.MonthAgo,.YearAgo,.AllTime]
    }
    
    case DayAgo = "A day ago"
    case WeekAgo = "A week ago"
    case MonthAgo = "A month ago"
    case YearAgo = "A year ago"
    case AllTime = "All time"

}

func formatDate(currentDate: Date, task: DateFilter) -> String {
    
    switch task {
    case .DayAgo:
        let dayPrior = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)
        return dayPrior!.ISO8601Format()
    case .WeekAgo:
        let weekPrior = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)
        return weekPrior!.ISO8601Format()
    case .MonthAgo:
        let monthPrior = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        return monthPrior!.ISO8601Format()
    case .YearAgo:
        let yearPrior = Calendar.current.date(byAdding: .year, value: -1, to: currentDate)
        return yearPrior!.ISO8601Format()
    case .AllTime:
        let allTime = Calendar.current.date(byAdding: .year, value: -20, to: currentDate)
        return allTime!.ISO8601Format()
    }
    
}

func formatDateDisplay(dateString: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd"
    
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "dd/MM/yyyy"
    
    if let date = dateFormatterGet.date(from: dateString) {
        return dateFormatterPrint.string(from: date)
    } else {
        return ""
    }
}

