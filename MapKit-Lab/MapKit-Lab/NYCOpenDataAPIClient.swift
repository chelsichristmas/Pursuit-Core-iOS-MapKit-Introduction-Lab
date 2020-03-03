//
//  NYCOpenDataAPIClient.swift
//  MapKit-Lab
//
//  Created by Chelsi Christmas on 3/3/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation
import NetworkHelper
struct NYCOpenDataAPIClient {
    
    static func getLocations(completion: @escaping (Result<[OpenData], AppError>) -> ()) {
        
        
        let endpoint = "https://data.cityofnewyork.us/resource/uq7m-95z8.json"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(.badURL(endpoint)))
            return
        }
        
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let search = try JSONDecoder().decode([OpenData].self, from: data)
                    completion(.success(search))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
    }

    
}
