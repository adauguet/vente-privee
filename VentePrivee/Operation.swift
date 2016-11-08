//
//  Operation.swift
//  VentePrivee
//
//  Created by Antoine DAUGUET on 01/11/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import Foundation

struct Operation {
    
    let id: Int
    let brand: String
}

extension Operation {
    
    init?(json: JSON) {
        guard
            let operation = json["Operation"] as? JSON,
            let id = operation["Id"] as? Int,
            let brand = json["BrandAlert"] as? String else { return nil }
        self.id = id
        self.brand = brand
    }
}

extension Operation {
    
    static let all = Resource<[Operation]>(url: Router.operations, parse: { json in
        if let homeParts = json["HomeParts"] as? [JSON] {
            var operations = [Operation]()
            for homePart in homeParts {
                if let banners = homePart["Banners"] as? [JSON] {
                    operations += banners.flatMap { return Operation(json: $0) }
                }
            }
            return operations
        } else { return nil }
    })
}
