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
        
        WebService().load(route: Router.authenticate) {
            
            let operation = Operation(id: 60443, brand: "Calvin Klein")
            
            WebService().load(resource: Universe.root(operation: operation)) { universe in
                if let universe = universe {
                    print(universe)
                }
            }
            
            WebService().load(resource: Operation.all) { operations in
                if let operations = operations {
                    print(operations)
                }
            }
        }
        
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
                        
                        Alamofire.request(Router.universe(operation: operation)).validate().responseJSON { response in
                            switch response.result {
                            case .success(let value):
                                if let json = value as? JSON, let datas = json["datas"] as? JSON, let universe = Universe(json: datas) {
                                    
                                    Alamofire.request(Router.salespaceContent(universe: universe)).validate().responseJSON { response in
                                        switch response.result {
                                        case .success(let value):
                                            if let json = value as? JSON, let datas = json["datas"] as? JSON, let productFamilies = datas["productFamilies"] as? [JSON] {
                                                let families = productFamilies.flatMap { Family(json: $0) }
                                                
                                                for family in families {
                                                    for product in family.products {
                                                        Alamofire.request(Router.add(family: family, product: product, quantity: 1)).validate().responseJSON { response in
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
