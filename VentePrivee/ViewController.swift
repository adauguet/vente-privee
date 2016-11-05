//
//  ViewController.swift
//  VentePrivee
//
//  Created by Antoine DAUGUET on 31/10/2016.
//  Copyright © 2016 Antoine DAUGUET. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(Router.authenticate).responseData { response in
            switch response.result {
            case .success:
                
                Alamofire.request(Router.operations).responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        var operations: [Operation] = []
                        if let json = value as? JSON, let homeParts = json["HomeParts"] as? [JSON] {
                            for homePart in homeParts {
                                if let banners = homePart["Banners"] as? [JSON] {
                                    operations += banners.flatMap { return Operation(json: $0) }
                                }
                            }
                        }
                        
                        let operation = Operation(id: 60443, brand: "Calvin Klein")
                        
                        Alamofire.request(Router.universes(operation: operation)).validate().responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                if let json = value as? JSON, let datas = json["datas"] as? JSON, let universe = Universe(json: datas) {
                                    
                                    Alamofire.request(Router.salespaceContent(universe: universe)).validate().responseJSON { response in
                                        switch response.result {
                                        case .success(let value):
                                            if let json = value as? JSON, let datas = json["datas"] as? JSON, let productFamilies = datas["productFamilies"] as? [JSON] {
                                                let families = productFamilies.flatMap { Family(json: $0) }
                                                
                                                if let family = families.first {
                                                    if let product = family.products.first {
                                                        let request = Router.add(family: family, product: product, quantity: 1)
                                                        
                                                        Alamofire.request(request).validate().responseJSON { response in
                                                            switch response.result {
                                                            case .success(let value):
                                                                print(value)
                                                            case .failure(let error):
                                                                print(error)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            print(error)
                                        }
                                    }
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
