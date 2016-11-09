//
//  WebService.swift
//  VentePrivee
//
//  Created by Antoine DAUGUET on 01/11/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import Foundation
import Alamofire

typealias JSON = [String : Any]

final class WebService {
    
    static let shared = WebService()
    private init() {}
    
    func send(route: URLRequestConvertible, completion: @escaping () -> (), failure: @escaping (Error) -> ()) {
        Alamofire.request(route).validate().responseData { response in
            switch response.result {
            case .success:
                completion()
            case .failure(let error):
                failure(error)
            }
        }
    }
        
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> (), failure: @escaping (Error) -> ()) {
        Alamofire.request(resource.url).validate().responseJSON { response in
            switch response.result {
            case .success(let value as JSON):
                completion(resource.parse(value))
            case .failure(let error):
                failure(error)
            default:
                print(response) // This should never happen
            }
        }
    }
}
