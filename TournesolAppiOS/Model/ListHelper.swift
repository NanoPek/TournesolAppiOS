//
//  ListHelper.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 22/04/2023.
//

import Foundation


let itemsFromEndThreshold = 15

func thresholdMeet(_ itemsLoadedCount: Int, _ index: Int) -> Bool {
    return (itemsLoadedCount - index) == itemsFromEndThreshold
}
