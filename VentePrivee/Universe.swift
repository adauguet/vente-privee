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
}

extension Universe {
    
    init?(json: JSON) {
        guard
            let id = json["universeId"] as? Int,
            let name = json["name"] as? String else { return nil }
        self.id = id
        self.name = name
    }
}

extension Universe {
    
    static func root(operation: Operation) -> Resource<Universe> {
        return Resource<Universe>(url: Router.universe(operation: operation)) { json -> Universe? in
            guard let datas = json["datas"] as? JSON, let universe = Universe(json: datas) else {
                return nil
            }
            return universe
        }
    }
}
