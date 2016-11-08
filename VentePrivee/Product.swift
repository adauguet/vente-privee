//
//  Product.swift
//  VentePrivee
//
//  Created by Antoine DAUGUET on 04/11/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import Foundation

struct Product {
    
    var id: Int
    var name: String
    var description: String
}

extension Product {
    
    init?(json: JSON) {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let description = json["designation"] as? String else { return nil }
        self.id = id
        self.name = name
        self.description = description
    }
}
