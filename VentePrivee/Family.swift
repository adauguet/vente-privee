//
//  Family.swift
//  VentePrivee
//
//  Created by Antoine DAUGUET on 04/11/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import Foundation

struct Family {
    let id: Int
    let products: [Product]
    
    init?(json: JSON) {
        guard
            let id = json["id"] as? Int,
            let jsonProducts = json["products"] as? [JSON] else { return nil }
        self.id = id
        self.products = jsonProducts.flatMap { Product(json: $0) }
    }
}
