//
//  OpenData.swift
//  MapKit-Lab
//
//  Created by Chelsi Christmas on 3/3/20.
//  Copyright © 2020 Chelsi Christmas. All rights reserved.
//

import Foundation

struct OpenData: Codable & Equatable {
    
    let schoolName: String
    let latitude: String
    let longitude: String
    
    private enum CodingKeys: String, CodingKey {
     case schoolName = "school_name"
        case latitude
        case longitude
   
     }
}
