//
//  Router.swift
//  VentePrivee
//
//  Created by Antoine DAUGUET on 31/10/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case authenticate
    case operations
    case enter(operation: Operation)
    case universe(operation: Operation)
    case salespaceContent(universe: Universe)
    case add(family: Family, product: Product, quantity: Int)
    
    func asURLRequest() throws -> URLRequest {
        
        let baseURL = "https://secure.fr.vente-privee.com"
        
        let path: String = {
            switch self {
            case .authenticate:
                return baseURL + "/authentication/portal/FR"
            case .operations:
                return "http://fr.vente-privee.com/homev6/fr/Default/GetClientData"
            case .enter(let operation):
                return baseURL + "/ns-sd/frontservices/2.0/operation/enteroperation/\(operation.id)"
            case .universe(let operation):
                return baseURL + "/ns-sc/frontservices/2.0/salespace/getuniverses/10/\(operation.id)/1"
            case .salespaceContent(let universe):
                return baseURL + "/ns-sd/frontservices/2.0/salespace/getsalespacecontentbyuniverse/10/\(universe.id)/false"
            case .add:
                return baseURL + "/ns-sd/frontservices/2.0/basket/addproduct"
            }
        }()
        
        let parameters: [String : String] = {
            switch self {
            case .authenticate:
                return [
                    "Email" : "dauguet.antoine@gmail.com",
                    "Password" : "DevFright"
                ]
            case .operations:
                return ["homeName" : "Default"]
            case .add(let family, let product, let quantity):
                return [
                    "familyId" : String(family.id),
                    "productId" : String(product.id),
                    "quantity" : String(quantity)
                ]
            default:
                return [:]
            }
        }()
        
        let headers: [String : String] = {
            
            switch self {
            case .authenticate:
                return [
                    "Origin" : "https://secure.fr.vente-privee.com",
                    "Accept-Encoding" : "gzip, deflate, br",
                    "Accept-Language" : "en-GB,en-US;q=0.8,en;q=0.6",
                    "Upgrade-Insecure-Requests" : "1",
                    "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
                    "Content-Type" : "application/x-www-form-urlencoded",
                    "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                    "Cache-Control" : "max-age=0",
                    "Referer" : "https://secure.fr.vente-privee.com/authentication/portal/FR",
                    "Connection" : "keep-alive"
                ]
            case .add:
                return [
                    "Origin" : "https://secure.fr.vente-privee.com",
                    "Accept-Encoding" : "gzip, deflate, br",
                    "Accept-Language" : "en-US,en;q=0.8,fr;q=0.6",
                    "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36",
                    "Content-Type" : "application/json",
                    "Accept" : "application/json",
                    "Referer" : "https://secure.fr.vente-privee.com/ns/fr-fr/operation/59784/classic/3743782/catalog",
                    "Connection" : "keep-alive",
                    "X-VP-Web" : "1.2.9",
                    "DNT" : "1"
                ]
            default:
                return [:]
            }
            
        }()
        
        let method: HTTPMethod = {
            switch self {
            case .authenticate, .add:
                return .post
            case .operations, .enter, .universe, .salespaceContent:
                return .get
            }
        }()
        
        let url = try path.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        for (key, value) in headers {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        switch self {
        case .add:
            return try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
}
