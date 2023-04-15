//
//  Recommendation.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 12/03/2023.
//

import Foundation

struct Recommendation: Hashable, Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [TournesolVideo]
}

struct TournesolVideo: Hashable, Codable {
    let uid: String
    let type: String
    let n_comparisons: Int
    let n_contributors: Int
    let metadata: Metadata
    let total_score: Float
    let tournesol_score: Float
}

extension TournesolVideo: Identifiable {
    var id: String { return uid }
}

struct Metadata: Hashable, Codable {
    let name: String
    let tags: [String]
    let views: Int
    let source: String
    let duration: Int
    let language: String
    let video_id: String
    let channel_id: String
    let publication_date: String
    let uploader: String
}

func callAPI(){
    guard let url = URL(string: "https://api.tournesol.app/polls/videos/recommendations/") else{
        return
    }


    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        if let data = data, let string = String(data: data, encoding: .utf8){
            print(string)
        }
    }

    task.resume()
}

func decodeAPI(completion: @escaping (Recommendation?) -> ()) {
        
    guard let url = URL(string: "https://api.tournesol.app/polls/videos/recommendations/") else{return}

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()
        
        if let data = data{
            do{
                let tasks = try decoder.decode(Recommendation.self, from: data)
                completion(tasks)
            }catch{
                print(error)
            }
        }
    }
    task.resume()
}

