//
//  Resource.swift
//  VentePrivee
//
//  Created by Antoine Dauguet on 07/11/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import Foundation
import Alamofire

struct Resource<A> {
    let url: URLRequestConvertible
    let parse: (JSON) -> A?
}
