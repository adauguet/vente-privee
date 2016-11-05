//
//  Universe.swift
//  VentePrivee
//
//  Created by Antoine DAUGUET on 03/11/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import Foundation

struct Universe {
    
    let id: Int
    let name: String
//    let subUniverses: [Universe]
    
    init?(json: JSON) {
        guard
            let id = json["universeId"] as? Int,
            let name = json["name"] as? String
            /* let subUniverses = json["subUniverses"] as? [JSON]*/ else { return nil }
        self.id = id
        self.name = name
//        self.subUniverses = subUniverses.flatMap { Universe(json: $0) }
    }
}
