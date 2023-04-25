//
//  MyRatedItems.swift
//  TournesolAppiOS
//
//  Created by Jérémie on 24/04/2023.
//

import Foundation


struct MyRatedItems: Hashable, Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [RatedEntity]
}

struct RatedEntity: Hashable, Codable {
    let entity: RatedTournesolVideo
    let n_comparisons: Int?
}

extension RatedEntity: Identifiable {
    var id: String { return entity.uid }
}

struct RatedTournesolVideo: Hashable, Codable {
    let uid: String
    let type: String
    let metadata: Metadata
}

func decodeAPIRated(parameters: [URLQueryItem] , urlString: String, token: String, completion: @escaping (MyRatedItems?) -> ()) {
    
    var url = URLComponents(string: urlString)!
    url.queryItems = parameters
        
    var request = URLRequest(url: url.url!)
    request.httpMethod = "GET"
    
    request.addValue("Bearer \(token)", forHTTPHeaderField: "authorization")

    let task = URLSession.shared.dataTask(with: request){
        data, response, error in
        
        let decoder = JSONDecoder()
        
        if let data = data{
            do{
                let tasks = try decoder.decode(MyRatedItems.self, from: data)
                completion(tasks)
            }catch{
                print(error)
            }
        }
    }
    task.resume()
}
