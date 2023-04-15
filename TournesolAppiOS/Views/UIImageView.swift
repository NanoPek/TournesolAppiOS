//
//  UIImageView.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 26/03/2023.
//

import Foundation

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}


