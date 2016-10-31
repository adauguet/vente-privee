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
    
    func asURLRequest() throws -> URLRequest {
        
        let path: String = {
            switch self {
            case .authenticate:
                return "https://secure.fr.vente-privee.com/authentication/portal/FR"
            }
        }()
        
        let headers: [String : String] = {
            return [
                "Accept-Encoding" : "gzip, deflate, sdch, br",
                "Accept-Language" : "en-GB,en-US;q=0.8,en;q=0.6",
                "Upgrade-Insecure-Requests" : "1",
                "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36",
                "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                "Cache-Control" : "max-age=0",
                "Connection" : "keep-alive"
            ]
        }()
        
        let url = try path.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        
        return try URLEncoding.default.encode(urlRequest, with: nil)
    }
}
