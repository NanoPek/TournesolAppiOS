//
//  TaskFilter.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 15/04/2023.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

protocol StringOrStringList { }

extension String: StringOrStringList { }
extension [LanguageToken]: StringOrStringList { }

func durationToString(duration: Int) -> String {
    let hours = duration / 3600
    let minutes = (duration % 3600) / 60
    let seconds = duration % 60
    
    if hours > 0 {
        let hoursString = String(format: "%d", hours)
        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", seconds)
        return "\(hoursString):\(minutesString):\(secondsString)"
    } else {
        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", seconds)
        return "\(minutesString):\(secondsString)"
    }
}


func formatViews(views: Int) -> String {
    if views >= 10000000 {
        let millions = views / 1000000
        return "\(millions)M views"
    } else if views >= 1000000 {
        let millions = Double(views) / 1000000.0
        return String(format: "%.1fM views", millions)
    } else if views >= 10000 {
        let thousands = views / 1000
        return "\(thousands)K views"
    } else if views >= 1000 {
        let thousands = Double(views) / 1000.0
        return String(format: "%.1fK views", thousands)
    } else {
        return "\(views) views"
    }
}

func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
     var result = lhs
     rhs.forEach{ result[$0] = $1 }
     return result
 }

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
